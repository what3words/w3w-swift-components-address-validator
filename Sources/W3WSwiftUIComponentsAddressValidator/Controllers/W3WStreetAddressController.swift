//
//  File.swift
//  
//
//  Created by Dave Duprey on 14/03/2022.
//

import Foundation
import W3WSwiftApi
import W3WSwiftAddressValidators


/// Takes events from the UI and send out commands
class W3WStreetAddressController {
  
  /// the data model to use for the app
  var model: W3WStreetAddressModel
  
  /// Takes events from the UI and send out commands
  /// - parameter model: the data model to use for the app
  init(model: W3WStreetAddressModel) {
    self.model = model
  }
  
  
  /// called when the use chooses voice
  func onVoiceChoosen() {
    model.startRecording()
  }
  
  
  /// called when the user chooses keyboard
  func onTextChosen() {
    model.showKeyboard()
  }
  
  
  /// called when the user enters text in
  func onWordsEntered(words: String) {
    model.dealWithText(words: words)
  }
  
  
  /// called when the microphone icon is tapped
  func onMicrophoneTap() {
    // if the settings allow it, toggle the recording mode
    if W3WSettings.tapTogglesRecording {
      
      // if the component is NOT communicating
      if model.state != .communicating {
        
        // either start or stop recording depending on the current state
        if model.isRecording() {
          model.stopRecording()
        } else {
          model.startRecording()
        }
      }
    }
  }
  
  
  func onCancel() {
    model.stopApiCalls()
    model.set(state: .idle)
    model.stopRecording()
  }

  
  func onAddressChosen(node: W3WValidatorNodeLeaf?, completion: @escaping (W3WStreetAddressProtocol?) -> ()) {
    if let n = node {
      model.addressChosen(address: n, onAddressSelected: completion)

    } else {
      model.set(state: .idle)
    }
  }
  
  
}
