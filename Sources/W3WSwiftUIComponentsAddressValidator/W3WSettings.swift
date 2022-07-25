//
//  File.swift
//  
//
//  Created by Dave Duprey on 15/11/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign


extension W3WSettings {

  static var tapTogglesRecording = true

#if os(watchOS) || os(iOS)

  static let micCircle                  = CGFloat(10.0) // CGFloat(76.0)
  static let micCircleHalo3Small        = CGFloat(96.0)
  static let micCircleHalo3Large        = CGFloat(216.0)

  static let smallestMaxVolume          = 0.001 

#endif
  
}
