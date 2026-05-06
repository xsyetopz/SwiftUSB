# Contributing

SwiftUSB follows the package layout expected by Swift Package Manager.

- Library code lives in `Sources/SwiftUSB`
- The libusb system module lives in `Sources/CLibUSB`
- Unit tests live in `Tests/SwiftUSBTests`
- Hardware-facing tests live in `Tests/HardwareTests`

Run the focused package check before submitting changes:

```sh
swift test
```

Keep public API changes source-backed by libusb behavior and add tests for new error mapping, transfer behavior, or descriptor parsing.
