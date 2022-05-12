//
//  File.swift
//  
//
//  Created by Dave Duprey on 15/11/2021.
//

import SwiftUI
import W3WSwiftApi


extension W3WSettings {

  static var tapTogglesRecording = true
  
  public static let w3wMicOnColor   = Color(red: 225/256,  green:  31/256,  blue:  38/256)
  public static let w3wMicOffColor  = Color(red: 256/256,  green: 256/256,  blue: 256/256)
  public static let micHaloColor    = Color(red: 225/256,  green:  31/256,  blue:  38/256)
  public static let w3wSlashesColor = Color(red: 256/256,  green: 256/256,  blue: 256/256)

#if os(watchOS) || os(iOS)

  static let micCircle                  = CGFloat(10.0) // CGFloat(76.0)
  static let micCircleHalo3Small        = CGFloat(96.0)
  static let micCircleHalo3Large        = CGFloat(216.0)

  static let smallestMaxVolume          = 0.001 

#endif
  
}
