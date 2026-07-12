# Getting Started

Open a libusb context, find matching devices, then claim an interface before reading or writing endpoint data.

```swift
import SwiftUSB

let context = try USBContext()
let devices = try context.findDevices(vendorID: 0x1234, productID: 0x5678)

if let device = devices.first {
    let handle = try device.openWithCapture(interface: 0)
    defer { try? handle.releaseInterface(0) }

    let data = try handle.readInterrupt(endpoint: 0x81, length: 64)
    print(data as NSData)
}
```

Install libusb before building the package. On macOS, use `brew install libusb`.

## Inspect the active configuration

Configuration descriptors own their parsed interface, alternate-setting, and endpoint values, so they remain valid after libusb releases its descriptor allocation.

```swift
let configuration = try device.getActiveConfigurationDescriptor()
for interface in configuration.interfaces {
  for endpoint in interface.endpoints() {
    print(interface.bInterfaceNumber, endpoint.bEndpointAddress)
  }
}
```
