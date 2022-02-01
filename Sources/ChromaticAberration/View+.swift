//
//  View+.swift
//  Chromaticaberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

import SwiftUI
import CoreGraphics

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
  
  func asImage() -> UIImage {
    
    let controller = UIHostingController(rootView: self)
    let view = controller.view
    let targetSize = controller.view.intrinsicContentSize
    let bounds = CGRect(origin: .zero, size: targetSize)
    
    let window = UIWindow()
   
    window.rootViewController = controller
    window.makeKeyAndVisible()
    
    view?.bounds = bounds
    view?.backgroundColor = .clear
    
    let image = controller.view.asImage()
    
    return image
  }
}

extension UIView {
  func asImage() -> UIImage {
    
    let traitCollection = UITraitCollection(displayScale: 2.0)
    let format = UIGraphicsImageRendererFormat(for: traitCollection)
    
//    let format = UIGraphicsImageRendererFormat.default()
//    format.opaque = true
//    format.scale = 2
    
    let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}
