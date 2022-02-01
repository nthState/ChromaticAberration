//
//  File.swift
//  
//
//  Created by Chris Davis on 01/02/2022.
//

import Metal
import MetalKit
import UIKit

extension UIImage {
  
    func textureFromImage(device: MTLDevice) -> MTLTexture? {

        guard let cgImage = self.cgImage else {
            fatalError("Can't open image \(self)")
        }

        let textureLoader = MTKTextureLoader(device: device)
        let options = [MTKTextureLoader.Option.textureUsage: MTLTextureUsage.shaderRead.rawValue | MTLTextureUsage.shaderWrite.rawValue]
        do {
            let textureOut = try textureLoader.newTexture(cgImage: cgImage, options: options)
            return textureOut
        }
        catch {
            fatalError("Can't load texture")
        }

    }
}
