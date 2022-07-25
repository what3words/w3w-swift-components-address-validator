//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 20/12/2021.
//

import SwiftUI
import W3WSwiftUIInterfaceElements


/// text field for input
public struct W3WSuTextFieldWithButtons: View {

  let colors: W3WSuAddressValidatorColors
  var onEntry: (String) -> () = { _ in }
  var onCancel: () -> () = { }
  
  @State private var words: String = ""
  
  public init(colors: W3WSuAddressValidatorColors, onEntry: @escaping (String) -> () = { _ in }, onCancel: @escaping () -> () = { }) {
    self.colors = colors
    self.onEntry = onEntry
    self.onCancel = onCancel
  }
  
  public var body: some View {
    VStack {
      TextField(
        "eg: limit.broom.flip",
        text: $words
      )
      HStack {
        W3WSuSquareUtilButton(title: "Cancel", icon: Image(systemName: "xmark"), color: colors.clearButton.foreground.current.suColor, background: colors.clearButton.background.current.suColor) {
          onCancel()
        }
        W3WSuSquareUtilButton(title: "Select", icon: Image(systemName: "checkmark"), color: colors.confirmButton.foreground.current.suColor, background: colors.confirmButton.background.current.suColor) {
          onEntry(words)
        }
      }
    }
  }
}

