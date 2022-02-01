//
//  ChromaticAberration.swift
//  Chromaticaberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

import SwiftUI

public extension View {
  
  func chromaticAberration(red: CGPoint = .zero, green: CGPoint = .zero, blue: CGPoint = .zero) -> some View {
    modifier(ChromaticAberration(red: red, green: green, blue: blue))
  }
  
}

public struct ChromaticAberration: ViewModifier {
  
  private let red: CGPoint
  private let green: CGPoint
  private let blue: CGPoint
  
  public func body(content: Content) -> some View {
    
  }
  
}
