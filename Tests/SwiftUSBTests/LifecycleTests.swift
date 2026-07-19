// Copyright (c) 2026 Krystian J.
// SPDX-License-Identifier: MIT

import Foundation
import Testing

@testable import SwiftUSB

@Suite struct USBLifecycleTests {
  @Test func sessionRetainsDeviceAndContextUntilRelease() throws {
    let events = LifecycleEvents()
    var context: ContextOwner? = ContextOwner(events: events)
    let contextReference = WeakReference(context)
    var session: USBDeviceSession? = try makeSession(context: #require(context), events: events)
    #expect(session != nil)

    context = nil
    #expect(contextReference.value != nil)
    #expect(events.values == ["retain"])

    session = nil
    #expect(contextReference.value == nil)
    #expect(events.values == ["retain", "release-with-context", "context-deinit"])
  }

  @Test func handleKeepsSessionAliveThroughClose() throws {
    let events = LifecycleEvents()
    var context: ContextOwner? = ContextOwner(events: events)
    let contextReference = WeakReference(context)
    var session: USBDeviceSession? = try makeSession(context: #require(context), events: events)
    var handle: USBDeviceHandle? = USBDeviceHandle(
      handle: try fakePointer(bitPattern: 0x02),
      session: try #require(session)
    ) { _ in
      events.append(contextReference.value == nil ? "close-without-context" : "close-with-context")
    }
    #expect(handle != nil)

    context = nil
    session = nil
    #expect(contextReference.value != nil)

    handle = nil
    #expect(contextReference.value == nil)
    #expect(
      events.values == ["retain", "close-with-context", "release-with-context", "context-deinit"]
    )
  }

  private func makeSession(context: ContextOwner, events: LifecycleEvents) throws
    -> USBDeviceSession
  {
    let contextReference = WeakReference(context)
    return USBDeviceSession(
      device: try fakePointer(bitPattern: 0x01),
      contextOwner: context,
      retainDevice: { device in
        events.append("retain")
        return device
      },
      releaseDevice: { _ in
        events.append(
          contextReference.value == nil ? "release-without-context" : "release-with-context"
        )
      }
    )
  }

  private func fakePointer(bitPattern: Int) throws -> OpaquePointer {
    try #require(OpaquePointer(bitPattern: bitPattern))
  }
}

private final class ContextOwner {
  private let events: LifecycleEvents

  init(events: LifecycleEvents) { self.events = events }

  deinit { events.append("context-deinit") }
}

private final class LifecycleEvents: @unchecked Sendable {
  private var storage: [String] = []
  private let lock = NSLock()

  var values: [String] { lock.withLock { storage } }

  func append(_ value: String) { lock.withLock { storage.append(value) } }
}

private final class WeakReference<Value: AnyObject>: @unchecked Sendable {
  weak var value: Value?

  init(_ value: Value?) { self.value = value }
}
