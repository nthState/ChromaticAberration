# ``ChromaticAberration``

A View Modifier to shift colour

## Overview

| Before | After |
|--------|-------|
![Before](01_Aberration.png)|![After](03_Aberration.png)



```
import SwiftUI
import ChromaticAberration

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

## Topics

### Guides

- <doc:Getting-Started-with-ChromaticAberration>
