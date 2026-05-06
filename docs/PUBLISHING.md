# Publishing SwiftUSB

Swift Package Manager discovers releases from semantic version Git tags such as `0.1.0`, `0.1.1`, and `1.0.0`.

## Release checklist

1. Run the package tests:

   ```sh
   swift test
   ```

2. Commit the release-ready package state.

3. Create a plain semantic version tag such as `0.1.0` and push `main` with tags. Swift Package Manager resolves `0.1.0`, not `v0.1.0`.

4. Consumers can add SwiftUSB with:

   ```swift
   .package(url: "https://github.com/xsyetopz/SwiftUSB.git", from: "0.1.0")
   ```

## Local development

OpenJoystickDriver can consume a sibling checkout while SwiftUSB is developed locally:

```swift
.package(path: "../SwiftUSB")
```

Keep the package manifest free of OpenJoystickDriver-only paths so the repository stays usable by other Swift Package Manager clients.
