# Publishing SwiftUSB

Swift Package Manager discovers releases from semantic version Git tags such as
`0.1.0`, `0.1.1`, and `1.0.0`.

## Release checklist

1. Synchronize the release version across the package, update `CHANGELOG.md`,
   and commit the release-ready state:

   ```sh
   ./scripts/bump-version.py 0.1.2
   ```

2. Merge the release commit into `main` and wait for CI to pass.

3. In GitHub Actions, run the **Release** workflow from `main` and enter the
   version. The workflow validates current `main`, reruns the full checks,
   creates the source archive, and then creates both the plain semantic version
   tag and GitHub Release. Do not create or push the release tag manually.

Swift Package Manager resolves `0.1.2`, not `v0.1.2`.

Consumers can add SwiftUSB with:

```swift
.package(url: "https://github.com/xsyetopz/SwiftUSB.git", from: "0.1.2")
```

## Local development

OpenJoystickDriver can consume a sibling checkout while SwiftUSB is developed locally:

```swift
.package(path: "../SwiftUSB")
```

Keep the package manifest free of OpenJoystickDriver-only paths so the
repository stays usable by other Swift Package Manager clients.
