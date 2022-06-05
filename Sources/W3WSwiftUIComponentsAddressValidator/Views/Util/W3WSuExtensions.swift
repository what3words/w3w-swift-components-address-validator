//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/11/2021.
//

import SwiftUI


extension View {
  /// Neutralizes the iOS 14 behavior of capitalizing all text inside a List header
  @ViewBuilder func w3wUnCapitalized() -> some View {
    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
      self.textCase(.none)
    } else {
      self // no-op on iOS 13 et al.
    }
  }
}
