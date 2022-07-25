//
//  File.swift
//  
//
//  Created by Dave Duprey on 05/01/2022.
//

import Foundation
import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftUIInterfaceElements
import UIKit


/// hold colours for the component
public class W3WSuAddressValidatorColors {
  
  /// colors for most elements
  public var main = W3WColorSet.whiteGrayRed
  
  /// colors for the clear button
  public var clearButton: W3WTwoColor
  
  /// colors for the confirm button
  public var confirmButton: W3WTwoColor

  /// initialize colors
  /// - parameter main: colour set for the component
  /// - parameter clearButton: colours to use for the clear button
  /// - parameter confirmButton: colours for the confirm button
  public init(
    main:          W3WColorSet = .whiteGrayRed,
    clearButton:   W3WTwoColor = W3WTwoColor(foreground: W3WColor(all: .black.with(alpha: 0.6)), background: W3WColor(all: .coral)),
    confirmButton: W3WTwoColor = W3WTwoColor(foreground: W3WColor(all: .black.with(alpha: 0.6)), background: W3WColor(all: .brightGreen))
  ) {
      self.main = main
      self.clearButton = clearButton
      self.confirmButton = confirmButton
    }
  
}

