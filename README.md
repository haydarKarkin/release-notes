# release-notes

My personal site: a CV and a few articles about iOS tooling, built with
[DocC](https://www.swift.org/documentation/docc/) and deployed to GitHub Pages.

Live at **https://www.haydarkarkin.com**

## Structure

```
Sources/ReleaseNotes/ReleaseNotes.docc/
├── ReleaseNotes.md               ← Home page
├── header.html                   ← Site header (custom template)
├── Articles/
│   ├── Experience.md             ← Changelog (work history)
│   ├── Skills.md                 ← Dependencies (tech stack)
│   ├── Education.md              ← Build History
│   ├── DoccPipeline.md           ← Patch Notes: generated and written DocC docs
│   └── AsyncSequenceOperator.md  ← Patch Notes: a custom AsyncSequence operator
├── Resources/                    ← Card images, light and ~dark
└── theme-settings.json           ← Colors and typography
```

## Local Preview

```bash
swift package --disable-sandbox preview-documentation --target ReleaseNotes \
  --experimental-enable-custom-templates
```

Then open the URL it prints (http://localhost:8080/documentation/releasenotes/
by default).

## Deployment

Every push to `main` runs `.github/workflows/deploy.yml`. It builds the catalog
with `swift-docc-plugin`, adds a root redirect to `/documentation/releasenotes/`
and deploys the result to the `gh-pages` branch, which GitHub Pages serves on
the custom domain in `CNAME`.

Pages setup: **Settings → Pages → Source: Deploy from a branch → `gh-pages` →
`/ (root)`**
