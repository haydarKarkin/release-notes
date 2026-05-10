# release-notes

My personal dev hub — built with [DocC](https://www.swift.org/documentation/docc/) and deployed to GitHub Pages.

Live at: **https://haydarkarkin.github.io/release-notes/documentation/releasenotes/**

## Structure

```
Sources/ReleaseNotes/ReleaseNotes.docc/
├── ReleaseNotes.md          ← Home page
├── Articles/
│   ├── Experience.md        ← Changelog (career history)
│   ├── Skills.md            ← Dependencies (tech stack)
│   ├── Education.md         ← Build History
│   └── Blog/
│       └── *.md             ← iOS development posts
├── Resources/               ← Images, assets
└── theme-settings.json      ← Colours & typography
```

## Local Preview

```bash
swift package \
  --allow-writing-to-directory /tmp/docs \
  generate-documentation \
  --target ReleaseNotes \
  --output-path /tmp/docs \
  --transform-for-static-hosting \
  --hosting-base-path release-notes

# Then serve locally:
cd /tmp/docs && python3 -m http.server 8080
# Open: http://localhost:8080/documentation/releasenotes/
```

## Deployment

Push to `main` → GitHub Actions builds DocC → deploys to `gh-pages` branch → GitHub Pages serves it.

Set up: **Repo Settings → Pages → Source: Deploy from branch → `gh-pages` → `/ (root)`**
