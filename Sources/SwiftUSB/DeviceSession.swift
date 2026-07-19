// Copyright (c) 2026 Krystian J.
// SPDX-License-Identifier: MIT

import CLibUSB

/// Owns the libusb device reference and the context it was discovered from.
///
/// libusb device pointers are scoped to their originating context. Retaining both here keeps the
/// pointer valid after the discovery list is freed and until every device handle has closed.
final class USBDeviceSession: @unchecked Sendable {
  typealias RetainDevice = (OpaquePointer) -> OpaquePointer?
  typealias ReleaseDevice = (OpaquePointer) -> Void

  let device: OpaquePointer

  private let contextOwner: AnyObject
  private let releaseDevice: ReleaseDevice

  convenience init(device: OpaquePointer, contextOwner: USBContext) {
    self.init(
      device: device,
      contextOwner: contextOwner,
      retainDevice: libusb_ref_device,
      releaseDevice: libusb_unref_device
    )
  }

  init(
    device: OpaquePointer,
    contextOwner: AnyObject,
    retainDevice: RetainDevice,
    releaseDevice: @escaping ReleaseDevice
  ) {
    guard let retainedDevice = retainDevice(device) else {
      preconditionFailure("libusb_ref_device returned nil for a discovered device")
    }
    self.device = retainedDevice
    self.contextOwner = contextOwner
    self.releaseDevice = releaseDevice
  }

  deinit { withExtendedLifetime(contextOwner) { releaseDevice(device) } }
}
