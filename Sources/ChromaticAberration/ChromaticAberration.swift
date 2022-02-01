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
    modifier(ChromaticAberration(view: self, red: red, green: green, blue: blue))
  }
  
}

public struct AberrationConfiguration {
  let red: CGPoint
  let green: CGPoint
  let blue: CGPoint
}

public struct ChromaticAberration<V>: ViewModifier where V: View {
  
  private let view: V
  private let configuration: AberrationConfiguration
  
  @State var image: UIImage?
  @State var imageSize: CGSize = .zero
  
  public init(view: V, red: CGPoint = .zero, green: CGPoint = .zero, blue: CGPoint = .zero) {
    self.view = view
    self.configuration = AberrationConfiguration(red: red, green: green, blue: blue)
  }
  
  private func aberratedImage() async -> UIImage? {
    //try? await Task.sleep(nanoseconds: UInt64(0.032 * Double(NSEC_PER_SEC)))
    sleep(UInt32(0.032))
    let engine = MetalEngine.instance
    let snapshotImage = view.asImage()
    var texture = snapshotImage.textureFromImage(device: engine.device)
    engine.apply(newTex: &texture, configuration: configuration, size: CGSize(width: snapshotImage.cgImage!.width, height: snapshotImage.cgImage!.height))
    let outputImage = texture?.uiImage()
    
    self.imageSize = snapshotImage.size
    
    return outputImage
  }
  
  public func body(content: Content) -> some View {
    Group {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .frame(width: imageSize.width, height: imageSize.height)
      } else {
        view
      }
    }
    .padding(0)
    .task {
      image = await aberratedImage()
    }
  }
  
}
