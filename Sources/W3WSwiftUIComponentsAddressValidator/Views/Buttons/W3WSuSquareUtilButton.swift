//
//  SwiftUIView.swift
//  
//
//  Created by Dave Duprey on 18/12/2021.
//

import SwiftUI
import W3WSwiftApi


/// a square utility button
@available(iOS 13.0, *)
public struct W3WSuSquareUtilButton: View {
  
  var title: String
  var icon: Image
  var color: Color
  var background: Color
  var horizontal: Bool = false
  var action: () -> ()

  @State var disabled: Bool = false

  public init(title: String, icon: Image, color: Color, background: Color, horizontal: Bool = false, action: @escaping () -> ()) {
    self.title = title
    self.icon = icon
    self.color = color
    self.background = background
    self.action = action
  }

  
  public var body: some View {
    Button(action: action) {
      if horizontal == true {
        VStack {
          icon
          Text(title)
        }
      } else {
        HStack {
          icon
          Text(title)
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(minWidth: 16.0, idealWidth: 100.0, maxWidth: .infinity, minHeight: 50.0, idealHeight: 50.0, maxHeight: 90.0)
    //.padding(.horizontal, 12.0)
    //.padding(.vertical, 8.0)
    .foregroundColor(color)
    .background(background)
    .cornerRadius(8.0)
    .disabled(disabled)
  }
}


//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//      SwiftUIView(title: "Test", icon: Image(systemName: "mic.fill"), color: Color.blue, action: {})
//    }
//}
