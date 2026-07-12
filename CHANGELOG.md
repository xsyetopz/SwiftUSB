# Changelog

All notable changes to SwiftUSB are documented here.

## Unreleased

## 0.1.1 - 2026-07-12

### Added

- Expose owned interface, alternate-setting, and endpoint values from configuration descriptors.
- Add `USBDevice.getActiveConfigurationDescriptor()`.

### Fixed

- Populate `USBInterface.endpoints()` before libusb releases the source descriptor allocation.

## 0.1.0 - 2026-05-06

### Added

- Initial Swift Package Manager release of the Swift-native libusb wrapper.
- USB discovery, device handles, interface claiming, descriptors, and control, bulk, interrupt, and isochronous transfers.
