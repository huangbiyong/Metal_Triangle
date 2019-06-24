//
//  Render.swift
//  Meta-三角形
//
//  Created by huangbiyong on 2019/6/24.
//  Copyright © 2019 chase. All rights reserved.
//

import UIKit
import MetalKit


class Render: NSObject {

    let device: MTLDevice // GPU
    let commandQueue: MTLCommandQueue // 命令队列
    
    var verters: [Float] = [
           0,  0.5, 0,
        -0.5, -0.5, 0,
        0.5,  -0.5, 0
    ]
    
    var pipelineState: MTLRenderPipelineState? //管道状态
    var vertexBuffer: MTLBuffer? // 顶点数组缓存区
    
    init(device: MTLDevice!) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        
        // 1. 创建顶点缓存区
        self.vertexBuffer = device.makeBuffer(bytes: verters,
                                              length: verters.count * MemoryLayout<Float>.size, options: [])
        
        // 2. 设置管道状态
        let libary = device.makeDefaultLibrary()
        let vertextFuncion = libary?.makeFunction(name: "vertex_shader") // 设置顶点着色器
        let fragmentFuncion = libary?.makeFunction(name: "fragment_shader") // 设置片元着色器
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertextFuncion
        pipelineDescriptor.fragmentFunction = fragmentFuncion
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm // 设置颜色的像素格式为32位
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Render: MTKViewDelegate {
    
    // 试图大小改变时回调
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    // 每帧回调
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else {return}
        
        //  创建命令缓存区 / 命令编码器
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor) // 描述符
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)  // 设置如何从缓存数组读取顶点到命令缓存区
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: verters.count)
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable) //
        commandBuffer?.commit() // 
    }
}
