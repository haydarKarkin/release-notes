# Writing Your Own AsyncSequence Operator

What it takes to add an operator like `throttleFirst` to `AsyncSequence`, and
how to test it without waiting for real time to pass.

## Overview

The standard library gives `AsyncSequence` the basics: `map`, `filter`,
`compactMap`, `prefix`, `reduce`. Anything beyond that comes from
[swift-async-algorithms][aa] or from you.

Sometimes writing it yourself is the better trade. The semantics you need may
not be the ones the library offers, or you may not want another dependency in
a shared module. Either way it is around thirty lines once you know the shape,
and the shape is what this article is about.

The example is `throttleFirst`: pass the first element of every time window
through, drop everything that arrives before the window is over. Working code
with tests is in the [Throttling][repo] repository.

---

## The throttling logic

First the semantics, because "throttle" means different things in different
libraries. Mine is the leading edge variant. With a window of 100ms and
elements arriving at 0, 50, 110, 610 and 620ms:

| Arrives at | Result |
|---|---|
| 0ms | passes, window opens |
| 50ms | dropped, window still open |
| 110ms | passes, new window opens |
| 610ms | passes, new window opens |
| 620ms | dropped |

Now `next()`:

```swift
public mutating func next() async throws -> Element? {
    while let element = try await base.next() {
        let now = clock.now

        if let windowStart, windowStart.duration(to: now) < interval {
            continue
        }

        windowStart = now
        return element
    }

    return nil
}
```

The loop is the whole idea. Dropping an element does not mean returning
something, it means pulling the next one. A caller asking for one element can
make us pull ten from the base sequence. When the base sequence ends we return
`nil` and stop.

Note what is missing: no timer, no `Task`, no buffer. The operator only ever
looks at the clock when an element arrives. That keeps it cheap, and it is
also why cancellation needs no code of its own. There is nothing to cancel
except the `base.next()` we are suspended on, and that already handles it.

---

## Inject the clock

The obvious version of the code above reads `ContinuousClock.now` directly.
Do not do that. Make the operator generic over the clock instead:

```swift
public struct AsyncThrottleFirstSequence<Base: AsyncSequence, C: Clock>: AsyncSequence {
    public typealias Element = Base.Element

    let base: Base
    let interval: C.Duration
    let clock: C

    public struct Iterator: AsyncIteratorProtocol {
        var base: Base.AsyncIterator
        let interval: C.Duration
        let clock: C
        var windowStart: C.Instant?

        // next() as above
    }

    public func makeAsyncIterator() -> Iterator {
        Iterator(base: base.makeAsyncIterator(), interval: interval, clock: clock)
    }
}
```

It costs one generic parameter and it is the difference between tests that
sleep and tests that do not. More on that below.

Two smaller decisions in the same area.

Use a `Clock`, not `Date`. Wall clock time can jump backwards, on an NTP
correction or when the user changes the date. A window measured with `Date`
breaks when it does. `ContinuousClock` only moves forward.

`ContinuousClock` also keeps counting while the device is asleep, which is
what you want for throttling: if the app was suspended for an hour, the window
is over. If you want the opposite, `SuspendingClock` is the other option.

---

## The entry point

Nobody wants to write the generic type by hand, so add the operator to
`AsyncSequence` and give it a default clock:

```swift
public extension AsyncSequence {
    func throttleFirst<C: Clock>(
        for interval: C.Duration,
        clock: C,
    ) -> AsyncThrottleFirstSequence<Self, C> {
        AsyncThrottleFirstSequence(base: self, interval: interval, clock: clock)
    }

    func throttleFirst(
        for interval: Duration,
    ) -> AsyncThrottleFirstSequence<Self, ContinuousClock> {
        throttleFirst(for: interval, clock: ContinuousClock())
    }
}
```

Now it reads like any other operator:

```swift
for try await update in updates.throttleFirst(for: .milliseconds(500)) {
    render(update)
}
```

---

## Testing without waiting

A time based operator tested with real time gives you a slow suite and flaky
results on a loaded CI machine. Since the clock is injectable, we can do
better.

The trick is that a clock does not have to define its own instant type. Reuse
`ContinuousClock.Instant` and there is no `InstantProtocol` conformance to
write:

```swift
final class ManualClock: Clock, @unchecked Sendable {
    typealias Instant = ContinuousClock.Instant

    private let lock = NSLock()
    private var instant = ContinuousClock.now

    var now: Instant { lock.withLock { instant } }
    var minimumResolution: Duration { .zero }

    func advance(by duration: Duration) {
        lock.withLock { instant = instant.advanced(by: duration) }
    }

    func sleep(until deadline: Instant, tolerance: Duration?) async throws {}
}
```

The empty `sleep` looks like cheating. It is safe here for one specific
reason: our operator never sleeps, it only reads `now`. An operator that does
sleep, like `debounce`, needs a clock that can actually park a task and wake
it up, and that is a much bigger piece of test code.

The second helper describes arrival times. It is a base sequence that moves
the clock forward as it produces elements:

```swift
struct ScriptedSequence: AsyncSequence {
    let script: [(value: Int, after: Duration)]
    let clock: ManualClock

    struct Iterator: AsyncIteratorProtocol {
        ...
        mutating func next() async -> Int? {
            guard index < script.count else { return nil }

            let step = script[index]
            index += 1
            clock.advance(by: step.after)
            return step.value
        }
    }
}
```

With those two, the test reads like the table from earlier:

```swift
@Test("drops elements that arrive inside the window")
func dropsElementsInsideWindow() async throws {
    let clock = ManualClock()
    let base = ScriptedSequence(
        script: [
            (1, .zero),              // t = 0,   first element, passes
            (2, .milliseconds(50)),  // t = 50,  window still open, dropped
            (3, .milliseconds(60)),  // t = 110, window over, passes
            (4, .milliseconds(500)), // t = 610, window over, passes
            (5, .milliseconds(10)),  // t = 620, window still open, dropped
        ],
        clock: clock,
    )

    let result = try await collect(base.throttleFirst(for: .milliseconds(100), clock: clock))

    #expect(result == [1, 3, 4])
}
```

No sleeps, no tolerances, and the expected output is obvious from the input.
The suite in the repository also covers the boundary case, an empty base
sequence, and that errors from the base sequence are not swallowed. It runs in
about a millisecond.

There is one test left on the real `ContinuousClock`, to exercise the default
overload. It is written so that its assertion cannot depend on how fast the
machine is: every element is buffered before iteration starts, so a one second
window can only let the first one through. My first version of that test
produced values 20ms apart and asserted that some of them got dropped. It
failed the same day, on a loaded machine where each 20ms sleep took longer
than the window. Even the smoke test should not measure time.

---

## Two things that bite

**Filter before you throttle.** If the stream starts with a value you do not
care about, an empty snapshot from a realtime database for example, that value
opens the window and the first real value gets dropped. The fix is not in the
operator. Filter the noise out first, so the window starts on data that
matters:

```swift
updates
    .filter { !$0.isEmpty }
    .throttleFirst(for: .milliseconds(500))
```

I lost time to this one, and it is not visible in any marble diagram.

**The leading edge loses the last value.** If an element is dropped and then
the stream goes quiet, you never see it. For a progress counter that is fine.
For UI state it usually is not, because the state you are showing is one
update behind reality. If that matters, you want the newest element of the
window instead of the oldest, and that means buffering and waiting.

---

## When to use swift-async-algorithms instead

The package has `throttle(for:clock:latest:)`, and it does not work the way
the operator above does. From [its documentation][throttle-doc]:

> If values are produced by the base `AsyncSequence` the throttle does not
> resume its next iterator until the period has elapsed or unless a terminal
> event is encountered.

So it waits out the window and then emits, and `latest` decides whether you
get the newest or the oldest element of that window. Use it when you want the
newest value, or a reduction over the window, or simply do not want to own
this code.

Write your own when you want the leading edge with no waiting and no
buffering, when you cannot add a dependency, or when you want to understand
what these operators actually do. The last reason is the one that got me
started.

---

## Links

- [Throttling][repo], the example with tests
- [swift-async-algorithms][aa]
- [RxJS throttleTime][rxjs], the same semantics in another library

[aa]: https://github.com/apple/swift-async-algorithms
[repo]: https://github.com/haydarKarkin/Throttling
[throttle-doc]: https://github.com/apple/swift-async-algorithms/blob/main/Sources/AsyncAlgorithms/AsyncAlgorithms.docc/Guides/Throttle.md
[rxjs]: https://rxjs.dev/api/operators/throttleTime
