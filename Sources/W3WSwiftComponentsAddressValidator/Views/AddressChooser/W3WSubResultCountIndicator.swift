//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 30/11/2021.
//

import SwiftUI
import W3WSwiftApi


struct W3WSubResultCountIndicator: View {
  
  let display: String
  let color: Color
  
    var body: some View {
      Text(display)
        .foregroundColor(.white)
        .font(.footnote)
        .minimumScaleFactor(0.5)
        .padding(4.0)
        .frame(width: 28.0, height: 28.0)
        .background(Circle().fill(color))
        //.underlay(Circle().fill(color))
        //.overlay(Circle().fill(color)) //.frame(width: 24.0, height: 24.0))

      
//      ZStack {
//        Circle().foregroundColor(color)
//          .frame(width: 24.0, height: 24.0)
//        Text(display)
//          .font(.footnote)
//          .minimumScaleFactor(0.5)
//          .padding(4.0)
//          .frame(width: 28.0, height: 28.0)
//      }
    }
}

//struct W3WSubResultCountIndicator_Previews: PreviewProvider {
//    static var previews: some View {
//      W3WSubResultCountIndicator(display: ">", color: .red)
//    }
//}
