# Changelog

What I've shipped, company by company, newest first.

## Overview

12+ years of iOS work across banking, messaging, events and public transport.
Two of those jobs were on white-label platforms, where one codebase ships as
dozens of branded apps. The entries below are the short version. Ask me about
any of them.

---

## v5.0 · ioki

**Senior iOS Developer · Frankfurt, Germany · January 2024 – Present**

I work on the white-label iOS codebase (Swift, UIKit, SwiftUI) behind 70+
branded public transport apps. It is part of a mobility platform that has
served nearly 10 million passengers across 200+ transport services. I own the
ticketing and payment areas, and I work across the platform on real-time data,
testing, release tooling and documentation.

### Highlights

- **Ticketing redesign.** Led the redesign of the ticketing domain. It merged
  an in-house ticket shop and a third-party ticketing system into one state
  model and one flow, and then gained prebooking, preordering and cancellation.

- **Live ride tracking.** Rebuilt real-time ride tracking with Swift
  Concurrency and Firebase, so riders get a stable, up-to-date view of their
  trip.

- **App Store Connect for 70+ apps.** Automated the App Store Connect work for
  every app with GitHub Actions and the App Store Connect API, including
  accessibility declarations and metadata. Extended VoiceOver and right-to-left
  support in the apps themselves.

- **Lean and secure.** Removed a legacy third-party SDK and the feature stack
  built on it. I co-own dependency and security updates through a recurring
  patch day.

- **Documentation.** Introduced a DocC site for the team. CI generates the API
  reference from source and publishes it with the written guides on every
  release. <doc:DoccPipeline> describes the same approach on a small project.

- **Tests.** Ship features with unit, behavior and screenshot tests (XCTest,
  Swift Testing, Quick/Nimble). Extended the screenshot setup that renders
  every screen in fixed states, so visual regressions show up before release.

---

## v4.0 · Cisco

**Senior iOS Developer · Izmir, Turkey · June 2021 – September 2023**

Event apps on a white-label codebase. Each branded app was built, released and
retired within the life of a single event, with shared libraries across the
product line.

### Highlights

- **100+ apps, no iOS engineer needed.** Built the release tooling behind a
  self-service platform. App teams outside engineering set up branding in a
  web portal and shipped 100+ event apps to the App Store with our scripts.

- **Shared foundation library.** Created a common iOS library that several
  apps adopted. It removed roughly 3K lines of duplicated code per project.

- **70% faster setup.** Automated developer environment setup for toolchains
  and third-party dependencies.

- **Real-time data.** Led real-time data sync on Firebase for apps with 100K+
  monthly active users.

- **40% fewer defects.** Expanded unit and snapshot test coverage and kept
  code reviews consistent.

- **30% faster apps.** Profiled and optimized the native codebase together
  with the solutions architect.

---

## v3.0 · Ecospend

**Mobile Team Lead · Izmir, Turkey · March 2020 – June 2021**

My first lead role. I was the technical and people lead of a 7-person mobile
team with 6 direct reports, and owned the app architecture and the team's
delivery together with product and design.

### Highlights

- **Architecture.** Defined the architecture of the team's iOS apps, a
  reactive MVVM-C design with RxSwift and RxCocoa. Every new feature was built
  on it, and code and design reviews kept it consistent.

- **Interface-first features.** For each new feature I designed the
  protocols, services and managers it needed and wrote the key test cases it
  had to pass. Then an engineer on the team took the scaffold and built it out.

- **People.** Managed 6 engineers through regular one-on-ones. Together we
  delivered 2 new apps and refactored 3 existing ones on schedule.

- **Process.** Introduced Scrum and moved planning to Jira. Delivery became
  more predictable, and management could see progress directly.

- **Navigation redesign.** Owned the navigation redesign of an app with 300K+
  members, end to end with the UX team.

---

## v2.1 · Turkcell via Ericsson

**Senior iOS Developer · Izmir, Turkey · July 2019 – March 2020**

Worked on BiP, Turkcell's messaging app, with a focus on stability, the
messaging data layer and product analytics.

### Highlights

- **Stability at scale.** BiP had 3.5M monthly and 400K daily active users. I
  profiled it with Instruments and Crashlytics to find and fix memory leaks and
  crashes.

- **Messaging data layer.** Optimized the layer built on Core Data and XMPP:
  how conversations were stored, retrieved and synchronized.

- **Analytics.** Supported product analytics with Mixpanel and Google
  Analytics.

---

## v2.0 · IBTech

**Senior iOS Developer · Izmir, Turkey · January 2019 – July 2019**

Worked on the mobile banking app of QNB Finansbank, used by 3.5M mobile
customers in 2019.

### Highlights

- **Reusable components.** Built reusable iOS components and mentored other
  developers on the team.

- **Features and performance.** Delivered features and performance
  improvements, alongside code analysis and optimization.

---

## v1.1 · Linovi

**iOS Developer · Izmir, Turkey · April 2017 – January 2019**

Consumer iOS apps in a Scrum team, working closely with UX and backend.

### Highlights

- **Two App Store launches.** Launched and maintained *Innit* and *ShopWell*,
  including bug fixing, profiling and memory-leak work after release.

- **A step outside iOS.** Contributed to the React.js and Redux front end of
  a "Shazam for artists" project.

---

## v1.0 · Kentkart

**iOS Developer · Izmir, Turkey · April 2015 – April 2017**

Public transport apps for 15+ Turkish cities.

### Highlights

- **Three production apps.** Shipped *Kentkart*, *e-Komobil* and *AntalyaKart*
  to the App Store, from feature work through release and distribution.

- **Apple Watch app.** Built a watchOS companion app on my own initiative,
  with a designer on the UI. It stayed in the top 3 of the Apple Watch apps
  section on the Turkish App Store for months.

---

## v0.9 · Cybersoft

**Software Test Engineer · Izmir, Turkey · 2013 – 2015**

Where I started: functional and regression testing, test plans, and SQL-based
checks of large data transformations, from test design to defect tracking.
