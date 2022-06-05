//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 18/11/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftAddressValidators


public struct W3WSuAddressNodeView: View {

  @ObservedObject var model: W3WStreetAddressModel
  var node: W3WValidatorNode
  var onAddressSelected: (W3WValidatorNodeLeaf?) -> ()
  let colors: W3WSuAddressValidatorColors
  var onMicrophoneTap: () -> () = { }


  public init(model: W3WStreetAddressModel, node: W3WValidatorNode, onAddressSelected: @escaping (W3WValidatorNodeLeaf?) -> (), colors: W3WSuAddressValidatorColors, onMicrophoneTap: @escaping () -> () = { }) {
    self.model             = model
    self.node              = node
    self.onAddressSelected = onAddressSelected
    self.colors            = colors
    self.onMicrophoneTap   = onMicrophoneTap
  }

  
  public var body: some View {
    if let n = node as? W3WValidatorNodeLeaf {
      W3WSuStreetAddressFull(model: model, node: n, onAddressSelected: onAddressSelected, colors: colors, onMicrophoneTap: onMicrophoneTap)
      
    } else if let n = node as? W3WValidatorNodeList {
      W3WSuAddressChooser(model: model, node: n, colors: colors, onAddressSelected: onAddressSelected, onMicrophoneTap: onMicrophoneTap)

    } else if let n = node as? W3WValidatorNodeSuggestion {
      W3WSuAddressChooser(model: model, node: n, colors: colors, onAddressSelected: onAddressSelected, onMicrophoneTap: onMicrophoneTap)

    } else {
      Text(node.name)
        .background(colors.main.background.current.suColor)
    }
  }
  
  
  func getTitle(address: W3WValidatorNode?) -> String {
    var title = node.name
    
    if model.w3w.isPossible3wa(text: title) {
      title = ""
    }
    
    return title
  }
  
  
  }



//struct W3WAddressChooserSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//      W3WAddressChooserSwiftUI()
//    }
//}
