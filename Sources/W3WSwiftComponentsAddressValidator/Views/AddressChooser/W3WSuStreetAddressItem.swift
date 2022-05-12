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


public struct W3WSuStreetAddressItem: View {
  
  @ObservedObject var model: W3WStreetAddressModel
  var address: W3WValidatorNode
  let colors: W3WColorSet
  
  public init(model: W3WStreetAddressModel, address: W3WValidatorNode, colors: W3WColorSet) {
    self.model    = model
    self.address  = address
    self.colors   = colors
  }

  
  public var body: some View {
    HStack(alignment: .center, spacing: 2.0) {
      Spacer()
      if let _ = address as? W3WValidatorNodeList {
        Image(uiImage: UIImage(named: "thickpintripple", in: Bundle.module, with: nil)!)
          .resizable()
          .interpolation(.high)
          .frame(width: 16.0, height: 16.0, alignment: .center)
      } else {
        Image(uiImage: UIImage(named: "thickpin", in: Bundle.module, with: nil)!)
          .resizable()
          .interpolation(.high)
          .frame(width: 16.0, height: 16.0, alignment: .center)
      }
      Spacer()
      VStack(alignment: .leading, spacing: 0.0) {
        if let a = address as? W3WValidatorNodeList {
          Text(address.name)
            .font(.body)
            .bold()
            .foregroundColor(colors.foreground.current.suColor)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(3)
          Text(a.nearestPlace ?? "?")
            .foregroundColor(colors.secondary.current.suColor)
            .font(.footnote)
            //.foregroundColor(colors.listCellNearestPlace.current.suColor)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else if let a = address as? W3WValidatorNodeLeafInfo {
          Text(a.address?.description ?? "")
            .foregroundColor(colors.secondary.current.suColor)
        } else {
          Text(address.name)
            .font(.body)
            .bold()
            .foregroundColor(colors.foreground.current.suColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(3)
          if address.nearestPlace != nil {
            Text(address.nearestPlace ?? "?")
              .foregroundColor(colors.secondary.current.suColor)
              .font(.footnote)
              //.foregroundColor(colors.listCellNearestPlace.current.suColor)
              .minimumScaleFactor(0.5)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      
      if let a = address as? W3WValidatorNodeList {
        if let childCount = (a.subItemCount ?? a.children?.count),  model.service.supportsSubitemCounts {
          if childCount > 0 {
            W3WSubResultCountIndicator(display: String(childCount), color: colors.highlight.current.suColor)
          }
        } else {
          W3WSubResultCountIndicator(display: "＞", color: colors.background.current.suColor)
        }
      }
      Spacer()
    }
    .padding(4.0)
  }
  
}


//struct W3WStreetAddressItemSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//      W3WStreetAddressItemSwiftUI()
//    }
//}
