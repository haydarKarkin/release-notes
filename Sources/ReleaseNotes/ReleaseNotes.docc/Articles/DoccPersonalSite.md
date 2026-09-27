# Turning DocC into a Personal Site

What a personal site actually needs, and how far DocC gets you with each of
those things.

@Metadata {
    @PageImage(purpose: card, source: "card-site", alt: "A browser window with a header bar and two cards")
    @CallToAction(url: "https://github.com/haydarKarkin/release-notes", purpose: link, label: "View this site on GitHub")
}

## Overview

This site is a DocC catalog inside a Swift package. The content is Markdown,
a few images and one HTML file. I picked DocC because I already use it at
work and it builds in CI with one command. What I didn't know was how well it
would handle a site that isn't API reference.

So I made a list. A personal site doesn't need much, but it needs a few things
done well. Here is that list, and what DocC gave me for each item.

Everything is in the [repository][repo] of this site. When I say how the
renderer behaves, I checked it in the `docc-render` build that ships with
Xcode 26.5. Other versions may differ.

---

## The package underneath

DocC documents modules, so even a site with no real code needs one. Mine is a
Swift package with a single target and a single dependency:

```swift
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "ReleaseNotes",
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ReleaseNotes"
        )
    ]
)
```

The target folder holds the catalog, `ReleaseNotes.docc`, and one Swift file
so the target has something to compile:

```swift
// This file exists to anchor the DocC documentation target.
// All content lives in ReleaseNotes.docc/
public enum ReleaseNotes {}
```

That empty enum is all the code there is. It gives the catalog a module to
belong to, and the module's name is what the front page title refers to.

The plugin is what makes this pleasant. It adds two commands to
`swift package`: `preview-documentation` runs a local server that rebuilds
when you save, and `generate-documentation` writes the static site for
deployment. No Xcode project, no scheme, no `xcodebuild`. For a bigger project
that's not always enough, which is what <doc:DoccPipeline> is about. For a
personal site it's exactly right.

---

## 1. A front page that says who you are

A visitor should know within a few seconds whose site this is and what they
do. In DocC that's the module page, and any file whose title is the module
name in double backticks becomes it:

```
# ``ReleaseNotes``

Senior iOS Developer. I build iOS apps that keep working as they grow.

@Metadata {
    @TitleHeading("Welcome to")
    @DisplayName("Haydar Karkin")
    @PageColor(blue)
}
```

`@DisplayName` puts your name in the big title instead of the module name,
`@TitleHeading` replaces the small "Framework" label above it, and `@PageColor`
tints the header area behind both. The line under the title is the abstract.
People read it first. Give it more thought than the rest of the page.

---

## 2. A way to find things

A CV, some articles, maybe a project or two. That's only a handful of pages,
but a plain list of links makes them all look equally important. Cards work
better. One option turns the `Topics` section into a grid:

```
@Options {
    @TopicsVisualStyle(compactGrid)
}
```

Then each page declares its card image:

```
@Metadata {
    @PageImage(purpose: card, source: "card-changelog", alt: "A commit timeline")
}
```

I tried `detailedGrid` first, and the cards took over the whole front page.
Making the images smaller didn't help. The renderer gives card images a fixed
height and fills it with `object-fit: cover`, so the file only decides what
gets cropped. A `detailedGrid` image is 359px tall, or 249px on screens up to
1250px wide. `compactGrid` uses smaller cards at 235px, or 163px. Switching
was the whole fix.

Because of `cover`, keep the important part of the image in the middle. The
edges get cut at some widths.

Dark mode is handled by file name. Put `card-changelog~dark.svg` next to
`card-changelog.svg` and DocC shows the one that matches the theme. You still
reference it as `card-changelog`.

---

## 3. Your face and your links, on every page

A personal site is about a person, so a photo helps, and the contact links
should be one click away from every page instead of sitting on the front page
only.

My first guess was `@PageImage(purpose: icon)`. Wrong. The renderer draws the
icon as a decoration behind the header area, 250px wide at 15% opacity, which
suits a framework logo and turns a face into a ghost.

What I wanted was a small bar at the top of every page: photo, name, title,
LinkedIn and GitHub. DocC supports that with a custom template. Put a file
named `header.html` in the root of the catalog and build with one extra flag:

```bash
swift package --disable-sandbox preview-documentation \
    --target ReleaseNotes \
    --experimental-enable-custom-templates
```

The flag has to go into the `generate-documentation` call in CI too. If you
forget it, the header just doesn't show up. No error. So if it works locally
but not on the live site, check that first.

A few things about how the header is rendered:

**It's in a shadow DOM.** DocC wraps the file in a `<template>` and defines a
custom element, `<custom-header>`, that clones it into a shadow root. The
site's CSS can't reach inside and yours can't leak out, so the header needs all
of its own styles and can't touch anything else on the page.

**It knows the color scheme.** The element gets a `data-color-scheme`
attribute: `auto`, `light` or `dark`, depending on the site's appearance
setting. `auto` hands the choice to the system, so dark mode takes two rules:

```css
:host([data-color-scheme="dark"]) {
    --bg: #000000;
    --ink: #f5f5f7;
}
@media (prefers-color-scheme: dark) {
    :host([data-color-scheme="auto"]) {
        --bg: #000000;
        --ink: #f5f5f7;
    }
}
```

**It's copied into every page.** No separate request: the header is part of
each page's HTML. I put the photo in as a data URI so it doesn't depend on
where DocC stores images, and kept it tiny. 96 × 96 pixels, about 2 KB.

`footer.html` works the same way if you want one. I didn't need it, since the
header already has the links.

---

## 4. A link to the code

Articles that come with a repository should make the repository easy to find.
A link at the bottom of the page is easy to miss. A button in the header area
isn't:

```
@CallToAction(url: "https://github.com/haydarKarkin/Throttling", purpose: link, label: "View Throttling on GitHub")
```

`purpose` is `link` or `download`. Leave out `label` and DocC picks a default
text for you.

---

## 5. A look that's yours

It doesn't take much. For me it was one color and slightly rounder corners.
`theme-settings.json` in the catalog overrides the renderer's design tokens,
and every key under `theme` turns into a CSS custom property, so
`"border-radius": "12px"` becomes `--border-radius`, which the stylesheets use
in dozens of places with 4px as the fallback. Colors can have a `light` and a
`dark` value:

```json
{
  "theme": {
    "border-radius": "12px",
    "color": {
      "standard-blue": {
        "light": "hsl(211, 80%, 42%)",
        "dark": "hsl(211, 80%, 55%)"
      }
    }
  }
}
```

There's also a `features` section. I turned on quick navigation there, the
search that opens with a key press. Later I read the renderer source and saw
it's on by default. Harmless, but not needed.

---

## 6. Your own address

`yourname.github.io/something` works, but your own domain looks better on a CV.
GitHub Pages handles it with a `CNAME` file. There's one catch with DocC. All
pages live under `/documentation/releasenotes/`, so the root of the domain is
empty. My deploy job writes a small `index.html` there that redirects to the
front page.

Give that redirect a canonical link, and use the exact host from `CNAME`,
`www` included. Mine pointed at the domain without `www`, which only redirects
to the real one. It worked, but a canonical link should name the address that
actually serves the page.

---

That's the whole list. Most of it is Markdown and a few directives. The only
extra piece is `header.html` with its flag, and you only need that if you want
your name and links on every page.

[repo]: https://github.com/haydarKarkin/release-notes
