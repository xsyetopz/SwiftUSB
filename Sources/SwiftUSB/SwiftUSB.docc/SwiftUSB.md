# ``SwiftUSB``

SwiftUSB is a Swift 6.2 wrapper around libusb 1.0 for applications that need direct USB device access.

Use ``USBContext`` to enumerate devices, ``USBDevice`` to inspect descriptors, and ``USBDeviceHandle`` to claim interfaces and perform transfers.

## Overview

SwiftUSB keeps libusb visible at the package boundary through a private `CLibUSB` system library target while exposing Swift-native device, descriptor, transfer, and error types. The API is intentionally small: discover devices, open a handle, claim an interface, transfer data, and release resources automatically when handles deinitialize.

## Topics

### Device Discovery

- ``USBContext``
- ``USBDevice``

### Open Handles and Transfers

- ``USBDeviceHandle``
- ``USBControl``
- ``USBControlRecipient``

### Descriptors

- ``USBDescriptor``
- ``USBInterface``
- ``USBEndpoint``
- ``USBEndpointDirection``
- ``USBTransferType``

### Errors

- ``USBError``
- ``USBTimeoutError``

### Constants and Utilities

- ``USBConstants``
- ``USBUtil``
- ``endpointAddress(_:)``
- ``endpointDirection(_:)``
