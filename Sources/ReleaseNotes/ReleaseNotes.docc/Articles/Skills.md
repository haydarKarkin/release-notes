# Dependencies

The languages, frameworks and tools I work with, and where I've used them.

@Metadata {
    @PageImage(purpose: card, source: "card-dependencies", alt: "A package box")
}

## Overview

A list of tools says little on its own, so each group below notes where the
tool did real work. The details are in <doc:Experience>.

---

## Languages

- **Swift.** My main language, from UIKit apps to Swift Concurrency and
  Swift Package Manager modules.
- **Objective-C.** Still comfortable reading and changing it in mixed
  codebases.

---

## UI

- **UIKit** and **SwiftUI**, side by side in the same codebase at ioki.
- **Accessibility.** VoiceOver and right-to-left support across a
  white-label product.
- **watchOS.** A companion app at Kentkart that reached the top 3 of the Apple
  Watch apps section on the Turkish App Store.

---

## Concurrency and Reactive

| Tool | Where |
|------|-------|
| Swift Concurrency | Real-time ride tracking at ioki |
| Combine | Reactive state in iOS apps |
| RxSwift, RxCocoa | The reactive MVVM-C architecture I defined at Ecospend |

I also write my own `AsyncSequence` operators when the standard ones don't
fit. <doc:AsyncSequenceOperator> walks through one.

---

## Networking and Data

| Tool | Where |
|------|-------|
| REST APIs | Every job |
| GraphQL | Client work in iOS apps |
| Firebase Realtime Database | Real-time data at Cisco and ioki |
| Core Data | BiP's messaging data layer, with XMPP |
| Realm | Local persistence |
| SQL | Data checks since my test engineer days |

---

## Architecture

- **MVVM-C**, **MVVM** and **MVC**. MVVM-C is what I reach for when an app
  has many flows, since coordinators keep navigation out of the view models.
- **Modular apps with SPM.** Features and shared code as Swift packages.
- **White-label.** One codebase, many branded apps: 100+ event apps at Cisco,
  70+ transit apps at ioki.
- **Interface-first design.** Protocols and test cases before the
  implementation, which is how I ran new features as a team lead.

---

## Testing

- **XCTest** and **Swift Testing** for unit tests.
- **Quick/Nimble** for behavior tests.
- **Snapshot and screenshot tests** that render screens in fixed states to
  catch visual regressions before release.

---

## CI and Release

| Tool | Use |
|------|-----|
| GitHub Actions | CI, and App Store Connect automation for 70+ apps |
| Fastlane | Builds, signing and App Store delivery |
| Bitrise, Codemagic | Hosted CI |
| SonarQube, Danger, SwiftLint | Static analysis, pull request checks, linting |

---

## Tooling

- **Tuist** for project generation.
- **DocC** for API reference and written guides. This site is built with it.
- **SwiftPM**, **CocoaPods** and **Carthage** for dependencies.
- **Instruments** and **Crashlytics** for profiling, memory leaks and crashes.
