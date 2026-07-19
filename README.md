# SwiftUSB

SwiftUSB is a Swift 6.1 wrapper around libusb 1.0, shaped as a pyusb-like
package for Swift programs. It provides a small, Swift-native API for listing
USB devices, reading owned configuration, interface, alternate-setting, and
endpoint descriptors, opening device handles, claiming interfaces, and issuing
control or interrupt transfers.

## Requirements

- Swift 6.1 or newer
- libusb 1.0
- macOS 10.15 or newer for the supported package target

Install libusb with Homebrew:

```sh
brew install libusb
```

On Debian or Ubuntu:

```sh
sudo apt install libusb-1.0-0-dev
```

## Build and Test

```sh
swift test
```

## Documentation

SwiftUSB ships DocC documentation in `Sources/SwiftUSB/SwiftUSB.docc`. CI also
builds a public symbol graph so publish candidates include generated API
documentation evidence.

Hardware tests live in `Tests/HardwareTests`. They expect a connected USB
device that matches the test probe requirements.

## Package Use

Use a local checkout during development:

```swift
.package(path: "../SwiftUSB")
```

Use the published repository after tagging a release:

```swift
.package(url: "https://github.com/xsyetopz/SwiftUSB.git", from: "0.1.2")
```

Add the library product to the target that talks to USB devices:

```swift
.product(name: "SwiftUSB", package: "SwiftUSB")
```

## Publishing

See `docs/PUBLISHING.md` for the release checklist. Swift Package Manager
consumes packages from Git tags. Prepare and merge the versioned release state,
then run the **Release** workflow from `main`. Actions runs the full checks
before it creates the semantic version tag and GitHub Release.

## License

[MIT](LICENSE)
