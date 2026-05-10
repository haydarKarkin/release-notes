# Dependencies

The tools, languages, and frameworks I reach for — and why.

## Overview

Over 12 years I've built up a stack that I'm genuinely comfortable with,
not just familiar with. Here's what I use and what I think of each.

---

## Core Languages

### Swift
My primary language. I've been writing Swift since the early days and have
watched it mature into one of the best-designed languages in the industry.
Strong opinions on value types, protocol-oriented design, and the right
use of generics.

### Objective-C
Still fluent. Legacy codebases don't scare me — bridging Swift and ObjC
in mixed projects is something I've done extensively.

---

## iOS Frameworks

| Framework | Depth |
|-----------|-------|
| UIKit | Expert — built complex custom UI, animations, layout systems |
| SwiftUI | Production experience, follow evolution closely |
| Core Data | Extensive — entity design, migration strategies, sync |
| Combine | Production use for reactive state management |
| Instruments | Deep profiling, memory leak detection, time profiling |

---

## Reactive Programming

- **RxSwift** — primary reactive framework across multiple projects
- **Combine** — preferred for new Swift-first codebases
- **ReactiveObjC** — legacy projects at Turkcell/Ericsson

---

## Networking

- **REST APIs** — standard, done this hundreds of times
- **GraphQL** — used at Ecospend
- **XMPP** — real-time messaging protocol at Turkcell (BIP)

---

## Architecture

I've worked in and led migrations between multiple patterns:

- **MVVM-C** — preferred for larger codebases; coordinators keep navigation testable
- **MVVM** — solid default for most projects
- **MVC** — understand its tradeoffs; can work with it, prefer to evolve away from it

Deeper principles I apply regardless of pattern: **SOLID**, **dependency injection**,
**protocol-oriented design**, **clean boundaries between layers**.

---

## Testing

- **Unit Testing** — XCTest, protocol mocking, test-driven features
- **Snapshot Testing** — iOSSnapshotTestCase; introduced at Cisco, cut defects 40%
- **BDD** — Behavior-Driven Development with Quick/Nimble

---

## CI/CD & Tooling

| Tool | Use |
|------|-----|
| Fastlane | Automated builds, signing, App Store deploys |
| Bitrise | Primary CI platform at Cisco and Ecospend |
| GitHub Actions | Used for open-source and personal projects |
| SonarQube | Static analysis, code quality gates |
| Danger | Automated PR checks and linting |
| SwiftLint | Code style enforcement |

---

## Databases

- **Realm** — real-time sync, change observation (Cisco)
- **Core Data** — complex entity graphs, multi-context setups (Turkcell)
- **SQL** — general relational DB knowledge

---

## Signature Practices

Beyond tools — the ways of working I bring to every team:

- **Functional & Reactive Programming**
- **Dependency Injection** — constructor injection preferred, DI containers when needed
- **Design Patterns** — practical application, not pattern-for-pattern's-sake
- **Code Review culture** — I give reviews that teach, not just approve or reject
- **Application Profiling** — Instruments is a first-class debugging tool for me
- **Agile / Scrum** — ran sprints as team lead, participated meaningfully as IC
