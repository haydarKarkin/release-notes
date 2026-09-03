# Combining Generated and Manual Docs

Building one documentation site from two sources: the API reference the
compiler generates, and the articles I write by hand.

## Overview

This site uses the [swift-docc-plugin][plugin]. One command and it works,
because this is a Swift package with a single target.

In bigger projects the setup is not that simple. An Xcode project with many
targets, a framework whose docs live in a separate folder, a site that also
carries onboarding pages. In those cases the plugin is not enough and you have
to run `docc` yourself.

Here is how I do it. Every step is implemented in [GardenKit][gardenkit], a
small package that only exists to be documented, so you can read the real
files instead of my snippets.

---

## The two halves

DocC can render two kinds of content.

**Generated API reference.** Types and functions with their doc comments. You
never write these pages. The compiler describes your module in a *symbol
graph*, one JSON file per module, and DocC turns it into pages.

**Manual documentation.** Articles and guides you write as Markdown inside a
*documentation catalog*, a folder ending in `.docc`.

Alone, neither is enough. The API reference says what a function returns, but
not why the feature exists. The guide explains the idea, but cannot link into
the code. Putting them together is one flag. The rest is the work around it.

---

## 1. Write the doc comments

Generated pages are only as good as the comments in the code. A one line
summary, then details, then the parameters. Keep the summary to one sentence,
because DocC reuses it as the subtitle in every list.

Only `public` and `open` symbols end up in the symbol graph, so
never show up on the website.

---

## 2. Add a catalog

The catalog can live anywhere. It does not have to be inside a target, because
you pass its path to `docc` directly:

```
doc/
└── GardenKit.docc/
    ├── GardenKit.md      # landing page
    └── Guides/
```

DocC flattens the catalog and finds pages by file name, so the folders are
only for your own order. Keep the file names unique.

One page becomes the front door. If you title a file with the module name in
double backticks, DocC merges it into the generated module page:
becomes the overview and your `Topics` groups set the order of everything
below. That is what GardenKit and this site do.

---

## 3. Get the symbol graphs

Now the generated half. Ask the compiler for symbol graphs while

```bash
xcodebuild build \
    -scheme "GardenKit" \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "$build_dir" \
    -quiet \
    OTHER_SWIFT_FLAGS="\$(inherited) -emit-symbol-graph -emit-symbol-graph-dir $symbol_graphs_dir"
```

Three details matter here.

`generic/platform=iOS Simulator` builds for the simulator SDK without picking
a device, so codesigning never runs. A docs job has nothing to s

`\$(inherited)` keeps the flags the project already sets. If you drop it, the
module compiles differently and you will not notice right away.

`build`, not `docbuild`. `xcodebuild docbuild` looks easier, but
documentation for the whole dependency tree. If one of those dependencies has
Objective-C headers, DocC's header pass can fail with duplicate symbol errors
and the build stops. A plain `build` never runs that pass. It on
the Swift symbol graphs, which is all DocC needs. This took me a while to
figure out.

---

## 4. Keep only your module

The build writes a graph for every module it compiled, including
dependencies. If you pass all of them to DocC, your dependencies
your website:

```bash
find "$symbol_graphs_dir" -type f -name '*.symbols.json' \
    ! -name 'GardenKit.symbols.json' \
    ! -name 'GardenKit@*.symbols.json' \
    -delete
```

Both patterns are needed. `GardenKit.symbols.json` has your own symbols.
`GardenKit@Foundation.symbols.json` is an extension graph, one per module you
extend. Delete those and every `extension Date` in your code qui
disappears from the site.

---

## 5. Put them together

This is the command everything was preparing for:

```bash
xcrun docc convert "doc/GardenKit.docc" \
    --additional-symbol-graph-dir "$symbol_graphs_dir" \
    --fallback-display-name "GardenKit" \
    --fallback-bundle-identifier "com.example.gardenkit" \
    --output-dir "$output_dir" \
    --transform-for-static-hosting \
    --emit-digest
```

`--additional-symbol-graph-dir` is the flag that merges the two
symbol links in your articles resolve because of it.

The two `--fallback-*` options give DocC the metadata Xcode would normally
pass for a target. A catalog you convert by hand has no target, so they are
required. `--transform-for-static-hosting` makes the output serv
file host, and `--emit-digest` writes the index the search needs.

While writing, use `preview` instead of `convert`. Same options,
`localhost:8080`, and reloads when you save a Markdown file. It reads the
symbol graphs from the folder you already created, so there is no rebuild.

---

## 6. Serve it

If the site is not at the root of the domain, pass the prefix or
URL will be wrong:

```bash
xcrun docc convert … --hosting-base-path "docs"
```

DocC does not write a root page either, so add a redirect:

```bash
echo '<script>window.location.href += "documentation/gardenkit"</script>' \
    > "$output_dir/index.html"
```

That is the whole pipeline. I keep it in a script with a `-o` fl
the docs are previewed locally, with it they are converted for hosting. The
full version is [in GardenKit][script]. In CI the output is just a folder of
static files, so publishing it is a copy.

---

## Common problems

- **`Topic reference 'Plant' couldn't be resolved.`** The symbol graphs did
  not reach DocC. Check the path you passed, and that pruning did not delete
  your own graph.
- **Extensions are missing.** The `Module@Other.symbols.json` graphs were
  deleted.
- **An internal type is missing.** Symbol graphs only contain public API.

---

## Links

- [GardenKit][gardenkit], the example, with the full script
- [DocC documentation][docc]
- [Formatting your documentation content][formatting]
- [SymbolKit][symbolkit], the symbol graph format

[plugin]: https://github.com/swiftlang/swift-docc-plugin
[gardenkit]: https://github.com/haydarKarkin/GardenKit
[script]: https://github.com/haydarKarkin/GardenKit/blob/main/scripts/generate_docs.sh
[docc]: https://www.swift.org/documentation/docc/
[formatting]: https://www.swift.org/documentation/docc/formattinnt
[symbolkit]: https://github.com/swiftlang/swift-docc-symbolkit
