//
//  File.swift
//  
//
//  Created by Dave Duprey on 29/07/2022.
//

import Foundation
#if !os(macOS)
import UIKit
#endif
#if os(watchOS)
import WatchKit
#endif
import W3WSwiftApi


extension W3WSettings {
  
  static let W3WSwiftComponentsAddressValidatorVersion = "v0.1.2"
  
  static let addresssValidatorHttpHeaderKey = "X-W3W-ADV-Component"
   
}
