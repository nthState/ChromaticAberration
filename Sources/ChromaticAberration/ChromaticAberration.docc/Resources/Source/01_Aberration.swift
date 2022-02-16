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
