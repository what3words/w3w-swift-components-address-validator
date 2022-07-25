//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 18/11/2021.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftAddressValidators


/// lists items from the W3WValidatorNode provided
public struct W3WSuAddressChooser: View {

  /// the data model
  @ObservedObject var model: W3WStreetAddressModel
  
  /// the node to show values for
  var node: W3WValidatorNode
  
  /// the colours to use
  let colors: W3WSuAddressValidatorColors
  
  /// closure called when the user selects an address
  var onAddressSelected: (W3WValidatorNodeLeaf?) -> ()
  
  /// the microphone button callback
  var onMicrophoneTap: () -> ()


  public init(model: W3WStreetAddressModel, node: W3WValidatorNode, colors: W3WSuAddressValidatorColors, onAddressSelected: @escaping (W3WValidatorNodeLeaf?) -> (), onMicrophoneTap: @escaping () -> () = { }) {
    self.model             = model
    self.node              = node
    self.colors            = colors
    self.onAddressSelected = onAddressSelected
    self.onMicrophoneTap   = onMicrophoneTap
  }


//#if os(watchOS)
  public var body: some View {
      ScrollView {
        VStack {
          W3WSuAddressListHeader(model: model, colors: colors.main, style: model.inputMethod == .mic ? .mic : .text, nearestPlace: node is W3WValidatorNodeSuggestion ? node.nearestPlace : nil, onMicrophoneTap: onMicrophoneTap)
          VStack(alignment: .leading) {
            if let n = node as? W3WValidatorNodeList {
              ForEach(n.children ?? [], id: \.name) { address in
                NavigationLink(destination: W3WSuAddressNodeView(model: model, node: address, onAddressSelected: onAddressSelected, colors: colors, onMicrophoneTap: onMicrophoneTap).onAppear(perform: { model.nodeSelected(node: address) } ) ) {
                  W3WSuStreetAddressItem(model: model, address: address, colors: colors.main)
                    .background(colors.main.background.current.suColor)
                      .navigationBarTitle(self.getTitle(address: address))
                  }
                    .buttonStyle(PlainButtonStyle())
                }
              }
            }
          }
      }
  }
//#else
//    public var body: some View {
//      NavigationView {
//        ScrollView {
//          VStack {
//            W3WAddressListHeaderSwiftUI(model: model, colors: colors, style: model.inputMethod == .mic ? .mic : .text, nearestPlace: node is W3WStreetAddressNodeSuggestion ? node.nearestPlace : nil, onMicrophoneTap: onMicrophoneTap)
//            VStack(alignment: .leading) {
//              if let n = node as? W3WStreetAddressNodeList {
//                ForEach(n.children ?? [], id: \.name) { address in
//                  NavigationLink(destination: W3WAddressNodeView(model: model, node: address, onAddressSelected: onAddressSelected, colors: colors, onMicrophoneTap: onMicrophoneTap).onAppear(perform: { model.nodeSelected(node: address) } ) ) {
//                    W3WStreetAddressItemSwiftUI(model: model, address: address, colors: colors)
//                      .background(colors.listCellBackground.themed.suColor)
//                      .navigationBarTitle(self.getTitle(address: address))
//                  }
//                  .buttonStyle(PlainButtonStyle())
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//#endif
    
    
//#if os(watchOS)
//      .w3wModify {
//        if #available(watchOS 8.0, iOS 14.0, *) {
//          $0.toolbar {
//            W3WStreetAddressButton(title: "Cancel", icon: Image(systemName: "xmark.circle.fill"), color: colors.clearButtonForegroundColor, background: colors.clearButtonBackgroundColor, horizontal: true) {
//              self.onAddressSelected(nil)
//            }
//            .padding()
//          }
//        }
//      }
//#endif
  
  
  func getTitle(address: W3WValidatorNode?) -> String {
    var title = node.name
    
    if model.w3w.isPossible3wa(text: title) {
      title = ""
    }
    
    return title
  }
  

  func modify<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> some View {
    return modifier(self)
  }
  
}


#if os(watchOS)
extension ScrollView {
  func w3wModify<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> some View {
    return modifier(self)
  }
}
#endif

