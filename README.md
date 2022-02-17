# Chris's SwiftUI Chromatic Aberration

A View Modifier to shift colour

## Overview

```
import SwiftUI
import ChromaticAberration~

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
    .chromaticAberration(red: CGPoint(x: 10, y: 4))
  }
  
}

```

| Before | After |
|--------|-------|
![Before](Sources/ChromaticAberration/ChromaticAberration.docc/Resources/Images/01_Aberration.png)|![After](Sources/ChromaticAberration/ChromaticAberration.docc/Resources/Images/03_Aberration.png)

