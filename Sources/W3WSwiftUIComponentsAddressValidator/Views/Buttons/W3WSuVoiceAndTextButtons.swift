//
//  VoiceTextButtons.swift
//  AddressValidation WatchKit Extension
//
//  Created by Dave Duprey on 18/12/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftUIInterfaceElements


/// a voice and a text button for the user to decide an input method
public struct W3WSuVoiceAndTextButtons: View {
  
  var colors: W3WColorSet
  var voiceAction: () -> ()
  var textAction: () -> ()
  
  public init(colors: W3WColorSet = .whiteGrayRed, voiceAction: @escaping () -> (), textAction: @escaping () -> ()) {
    self.colors = colors
    self.voiceAction = voiceAction
    self.textAction = textAction
  }

  public var body: some View {
    HStack {
      W3WSuSquareUtilButton(title: "Voice", icon: Image(systemName: "mic.fill"), color: colors.foreground.current.suColor, background: colors.background.current.suColor) {
        voiceAction()
      }
      W3WSuSquareUtilButton(title: "Text", icon: Image(systemName: "text.cursor"), color: colors.foreground.current.suColor, background: colors.background.current.suColor) {
        textAction()
      }
    }
  }
}

//struct VoiceTextButtons_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceTextButtons()
//    }
//}
