//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 18/11/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftAddressValidators
import W3WSwiftUIInterfaceElements


public enum W3WStreetAddressHeaderButtonStyle {
  case mic
  case text
  case none
}

public struct W3WSuAddressListHeader: View {
  
  @ObservedObject var model: W3WStreetAddressModel
  let colors: W3WColorSet
  var style = W3WStreetAddressHeaderButtonStyle.mic
  var nearestPlace:String? = nil
  var onMicrophoneTap: () -> ()

  public init(model: W3WStreetAddressModel, colors: W3WColorSet, style: W3WStreetAddressHeaderButtonStyle = .mic, nearestPlace: String? = nil, onMicrophoneTap: @escaping () -> ()) {
    self.model       = model
    self.colors       = colors
    self.style         = style
    self.nearestPlace   = nearestPlace
    self.onMicrophoneTap = onMicrophoneTap
  }

  public var body: some View {

    VStack(alignment: .center) {
      HStack(alignment: .center) {
        W3WSuVerticalWords(words: model.addressTree?.name ?? "", nearestPlace: nearestPlace, colors: colors)

        if style == .mic {
          Spacer()
          W3WSuMicrophoneButtonRound(colors: colors, onTap: onMicrophoneTap)
            .frame(width: 48.0, height: 48.0, alignment: .center)
            .padding(8.0)
        } else if style == .text {
          W3WSuRoundUtilButton(model: model, colors: colors)
        }
      }
    }
  }
  
  
  func getWord(number:Int) -> String {
    var word = "----"
    
    if let twa = model.addressTree?.name {
      if model.w3w.isPossible3wa(text: twa) {
        let wordArray = split(regex: W3WSettings.regex_3wa_separator, words: twa)
        if wordArray.count > number {
          word = wordArray[number]
        }
      }
    }
    
    return word
  }
  
  
  func split(regex pattern: String, words: String) -> [String] {
    
    guard let re = try? NSRegularExpression(pattern: pattern, options: [])
    else { return [] }
    
    let nsString = words as NSString // needed for range compatibility
    let stop = "☮︎"
    let modifiedString = re.stringByReplacingMatches(
      in: words,
      options: [],
      range: NSRange(location: 0, length: nsString.length), withTemplate: stop)
    return modifiedString.components(separatedBy: stop)
  }

  
}
