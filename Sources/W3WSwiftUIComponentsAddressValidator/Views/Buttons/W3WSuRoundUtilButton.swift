//
//  File.swift
//  
//
//  Created by Dave Duprey on 05/01/2022.
//

import SwiftUI
import W3WSwiftApi
import W3WSwiftDesign


/// a round utility button
@available(iOS 13.0, *)
struct W3WSuRoundUtilButton: View {
  
  @ObservedObject var model: W3WStreetAddressModel
  let colors: W3WColorSet
  
  var body: some View {
    Image(uiImage: UIImage(named: "cursor", in: Bundle.module, with: nil)!)
      .padding()
      .background(Circle().foregroundColor(colors.background.current.suColor))
      .onTapGesture {
        self.model.set(state: .reading)
      }
  }
}
