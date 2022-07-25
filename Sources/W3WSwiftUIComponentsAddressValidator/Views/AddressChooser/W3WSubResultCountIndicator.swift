//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 30/11/2021.
//

import SwiftUI
import W3WSwiftApi


/// a little circle with a number in it
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
    }
}

