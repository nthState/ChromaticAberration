//
//  ExampleSwiftUIView.swift
//  ChromaticAberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

import SwiftUI

struct ExampleSwiftUIView {}

extension ExampleSwiftUIView: View {
  
  var body: some View {
    content
      .padding(4)
  }
  
  var content: some View {
    HStack {
      Image("craig", bundle: Bundle.module)
      Text("Craig")
        .foregroundColor(Color.red)
    }
    .padding(10)
    .background(Color.green)
  }
  
}
  
#if DEBUG
struct ExampleSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ExampleSwiftUIView()
        .previewDisplayName("None")
      
      ExampleSwiftUIView()
        .chromaticAberration(red: CGPoint(x: 10, y: 4))
        .previewDisplayName("Red Aberration")
      ExampleSwiftUIView()
        .chromaticAberration(red: CGPoint(x: 10, y: 4))
        .previewDisplayName("Red Aberration")
      
      ExampleSwiftUIView()
        .chromaticAberration(green: CGPoint(x: 20, y: 0))
        .previewDisplayName("Green Aberration")
    }
  }
}
#endif

