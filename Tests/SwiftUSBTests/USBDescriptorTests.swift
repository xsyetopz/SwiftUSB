// Copyright (c) 2026 Krystian J.
// SPDX-License-Identifier: MIT

import Foundation
import Testing

@testable import SwiftUSB

@Suite struct USBDescriptorTests {

  @Test func sourceVersionMatchesRepositoryVersion() throws {
    let repositoryRoot = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
    let version = try String(
      contentsOf: repositoryRoot.appendingPathComponent("VERSION"),
      encoding: .utf8
    ).trimmingCharacters(in: .whitespacesAndNewlines)

    #expect(SwiftUSBVersion.current == version)
  }
  @Test func configurationOwnsInterfaceAlternatesAndEndpoints() throws {
    let input = USBEndpoint(
      bLength: 7,
      bDescriptorType: 5,
      bEndpointAddress: 0x81,
      bmAttributes: 0x03,
      wMaxPacketSize: 64,
      bInterval: 4,
      bRefresh: 0,
      bSynchAddress: 0,
      extraDescriptors: nil
    )
    let output = USBEndpoint(
      bLength: 7,
      bDescriptorType: 5,
      bEndpointAddress: 0x02,
      bmAttributes: 0x03,
      wMaxPacketSize: 64,
      bInterval: 4,
      bRefresh: 0,
      bSynchAddress: 0,
      extraDescriptors: nil
    )
    let alternate = USBInterface(
      bInterfaceNumber: 3,
      bAlternateSetting: 1,
      bInterfaceClass: 0xFF,
      endpoints: [input, output]
    )
    let configuration = USBConfigurationDescriptor(
      bConfigurationValue: 1,
      bNumInterfaces: 1,
      interfaces: [alternate]
    )

    let interface = try #require(configuration.interfaces.first)
    #expect(configuration.bNumInterfaces == 1)
    #expect(interface.bInterfaceNumber == 3)
    #expect(interface.bAlternateSetting == 1)
    #expect(interface.endpoints().map(\.bEndpointAddress) == [0x81, 0x02])
    #expect(interface.endpoint(at: 0)?.direction == .in)
    #expect(interface.endpoint(at: 1)?.direction == .out)
    #expect(interface.endpoint(at: 2) == nil)
  }

  @Test func endpointCollectionIsAnOwnedValue() {
    var source = [USBEndpoint.from(address: 0x81)]
    let interface = USBInterface(
      bInterfaceNumber: 0,
      bAlternateSetting: 0,
      bInterfaceClass: 0xFF,
      endpoints: source
    )

    source.removeAll()

    #expect(interface.endpoints().map(\.bEndpointAddress) == [0x81])
  }
}
