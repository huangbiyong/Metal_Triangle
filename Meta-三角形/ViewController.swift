//
//  ViewController.swift
//  Meta-三角形
//
//  Created by huangbiyong on 2019/6/24.
//  Copyright © 2019 chase. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    var metalView: MTKView {
        return view as! MTKView
    }
    var renderer: Render?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = MTLCreateSystemDefaultDevice()
        guard let device = d else {
            return
        }
        
        metalView.device = device
        metalView.clearColor = MTLClearColorMake(0.3, 0.3, 0.3, 1)
        renderer = Render(device: device)
        metalView.delegate = renderer
        
    }


}

