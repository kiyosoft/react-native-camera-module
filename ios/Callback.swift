//
//  Callback.swift
//  react-native-camera-module
//
//  Created by Kidus Solomon on 17/06/2022.
//

import Foundation

/**
 Represents a callback to JavaScript. Syntax is the same as with Promise.
 */
class Callback {
  private var hasCalled = false
  private let callback: RCTResponseSenderBlock

  init(_ callback: @escaping RCTResponseSenderBlock) {
    self.callback = callback
  }

  func reject(error: Any, cause: NSError?) {
    guard !hasCalled else { return }

    callback([NSNull(), error])
    hasCalled = true
  }

  func reject(error: String) {
    guard !hasCalled else { return }

    reject(error: error, cause: nil)
    hasCalled = true
  }

  func resolve(_ value: Any) {
    guard !hasCalled else { return }

    callback([value, NSNull()])
    hasCalled = true
  }

  func resolve() {
    guard !hasCalled else { return }

    resolve(NSNull())
    hasCalled = true
  }
}
