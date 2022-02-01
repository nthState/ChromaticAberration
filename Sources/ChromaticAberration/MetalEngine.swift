//
//  File.swift
//  
//
//  Created by Chris Davis on 01/02/2022.
//

import Metal

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
    defaultLibrary = device!.makeDefaultLibrary()!
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
    
    var r = UInt(configuration.red.x)
    var g = UInt(configuration.green.x)
    var b = UInt(configuration.blue.x)
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
    commandEncoder?.setComputePipelineState(pipelineState)
    commandEncoder?.setTexture(newTex, index: 0)
    commandEncoder?.setTexture(newTex, index: 1)
    commandEncoder?.setBytes(&r, length: MemoryLayout<UInt>.stride, index: 0)
    commandEncoder?.setBytes(&g, length: MemoryLayout<UInt>.stride, index: 1)
    commandEncoder?.setBytes(&b, length: MemoryLayout<UInt>.stride, index: 2)
    commandEncoder?.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
    commandEncoder?.endEncoding()
    commandBuffer?.commit();
    commandBuffer?.waitUntilCompleted()
    
  }
  
}
