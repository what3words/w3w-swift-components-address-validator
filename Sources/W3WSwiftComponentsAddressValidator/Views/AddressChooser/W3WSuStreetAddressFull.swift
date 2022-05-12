//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 30/11/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign
import W3WSwiftAddressValidators
import W3WSwiftUIInterfaceElements


struct W3WSuStreetAddressFull: View {
  
  @ObservedObject var model: W3WStreetAddressModel
  var node: W3WValidatorNodeLeaf
  var onAddressSelected: (W3WValidatorNodeLeaf) -> ()
  let colors: W3WSuAddressValidatorColors
  var onMicrophoneTap: () -> () = { }

  @Environment(\.presentationMode) var presentation
  
  var body: some View {
    ScrollView {
      //VStack {
      W3WSuAddressListHeader(model: model, colors: colors.main, style: model.inputMethod == .mic ? .mic : .text, onMicrophoneTap: onMicrophoneTap)
          .fixedSize(horizontal: false, vertical: true)
        //.scaledToFill()
        //.frame(height: 82.0)
          //.cornerRadius(8.0)
      W3WSuStreetAddressItem(model: model, address: node, colors: colors.main)
          .fixedSize(horizontal: false, vertical: true)
          .background(colors.main.background.current.suColor)
          .cornerRadius(8.0)
          //.scaledToFill()

          //.frame(height: 82.0)
        HStack {
          W3WSuSquareUtilButton(title: "Clear", icon: Image(systemName: "xmark"), color: colors.clearButton.foreground.current.suColor, background: colors.clearButton.background.current.suColor) {
            presentation.wrappedValue.dismiss()
          }
          W3WSuSquareUtilButton(title: "Confirm", icon: Image(systemName: "checkmark"), color: colors.confirmButton.foreground.current.suColor, background: colors.confirmButton.background.current.suColor) {
            onAddressSelected(node)
            //model.errorMessage = nil
            //model.set(state: .communicating)
            //model.addressChosen(address: node, onAddressSelected: onAddressSelected)
            presentation.wrappedValue.dismiss()
          }
        }
      //}
    }
  }
}


//struct W3WStreetAddressFullSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//      W3WStreetAddressFullSwiftUI()
//    }
//}
