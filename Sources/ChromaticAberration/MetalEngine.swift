//
//  MetalEngine.swift
//  ChromaticAberration
//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See https://github.com/nthState/ChromaticAberration/blob/main/LICENSE for license information.
//

import Metal
import MetalKit

class MetalEngine {
  
  public static var instance = MetalEngine()
  
  /// Metal function we are using
  private var kernelFunction:MTLFunction?
  /// Metal device, the GPU
  public var device: MTLDevice!
  /// Pipeline
  private var pipelineState: MTLComputePipelineState!
  /// Library
  private var defaultLibrary: MTLLibrary!
  /// Command queue
  private var commandQueue: MTLCommandQueue!
  /// Threading
  private var threadsPerThreadgroup:MTLSize!
  /// Thread Groups
  private var threadgroupsPerGrid: MTLSize!
  
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
  }
  
  public func apply(newTex: inout MTLTexture?, configuration: AberrationConfiguration, size: CGSize) {
    
    threadsPerThreadgroup = MTLSizeMake(16, 16, 1)
    let widthInThreadgroups = (Int(size.width) + threadsPerThreadgroup.width - 1) / threadsPerThreadgroup.width
    let heightInThreadgroups = (Int(size.height) + threadsPerThreadgroup.height - 1) / threadsPerThreadgroup.height
    threadgroupsPerGrid = MTLSizeMake(widthInThreadgroups, heightInThreadgroups, 1)
    
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
