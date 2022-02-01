//
//  ChromaticAberration.swift
//  Chromaticaberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/master/LICENSE for license information.
//

import Metal
import MetalKit

class MetalEngine {
  
  static var instance = MetalEngine()
  
  /// Metal function we are using
  var kernelFunction:MTLFunction?
  /// Metal device, the GPU
  var device: MTLDevice!
  /// Pipeline
  var pipelineState: MTLComputePipelineState!
  /// Library
  var defaultLibrary: MTLLibrary!
  /// Command queue
  var commandQueue: MTLCommandQueue!
  /// Threading
  var threadsPerThreadgroup:MTLSize!
  /// Thread Groups
  var threadgroupsPerGrid: MTLSize!
  
  private init() {
    device = MTLCreateSystemDefaultDevice()
    defaultLibrary = try! device!.makeDefaultLibrary(bundle: Bundle.module)
    commandQueue = device!.makeCommandQueue()
    
    kernelFunction = defaultLibrary.makeFunction(name: "kernel_chromatic_aberration")
    
    do {
      pipelineState = try device!.makeComputePipelineState(function: kernelFunction!)
    }
    catch {
      fatalError("Unable to create pipeline state")
    }
    
    threadsPerThreadgroup = MTLSizeMake(16, 16, 1)
    let widthInThreadgroups = (400 + threadsPerThreadgroup.width - 1) / threadsPerThreadgroup.width
    let heightInThreadgroups = (400 + threadsPerThreadgroup.height - 1) / threadsPerThreadgroup.height
    threadgroupsPerGrid = MTLSizeMake(widthInThreadgroups, heightInThreadgroups, 1)
  }
  
  func apply(newTex: inout MTLTexture?, configuration: AberrationConfiguration) {
    
    var rx = Int(configuration.red.x)
    var gx = Int(configuration.green.x)
    var bx = Int(configuration.blue.x)
    
    var ry = Int(configuration.red.y)
    var gy = Int(configuration.green.y)
    var by = Int(configuration.blue.y)
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
    commandEncoder?.setComputePipelineState(pipelineState)
    commandEncoder?.setTexture(newTex, index: 0)
    commandEncoder?.setTexture(newTex, index: 1)
    commandEncoder?.setBytes(&rx, length: MemoryLayout<Int>.stride, index: 0)
    commandEncoder?.setBytes(&gx, length: MemoryLayout<Int>.stride, index: 1)
    commandEncoder?.setBytes(&bx, length: MemoryLayout<Int>.stride, index: 2)
    commandEncoder?.setBytes(&ry, length: MemoryLayout<Int>.stride, index: 3)
    commandEncoder?.setBytes(&gy, length: MemoryLayout<Int>.stride, index: 4)
    commandEncoder?.setBytes(&by, length: MemoryLayout<Int>.stride, index: 5)
    commandEncoder?.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
    commandEncoder?.endEncoding()
    commandBuffer?.commit();
    commandBuffer?.waitUntilCompleted()
    
  }
  
}

struct MySize {
  var s: SIMD2<Int>
}
