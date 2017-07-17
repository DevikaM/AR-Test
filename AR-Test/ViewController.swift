//
//  ViewController.swift
//  AR-Test
//
//  Created by Devika Maharaj on 2017-07-16.
//  Copyright © 2017 Devika Maharaj. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var jellyNode: SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        let scene = SCNScene(named: "art.scnassets/Jellyfish.dae")!
        jellyNode = scene.rootNode.childNode(withName: "Jelly", recursively: true)
        jellyNode?.position = SCNVector3Make(0, 0, -1)

        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingSessionConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        let jellyClone = jellyNode!.clone()
        jellyClone.position = hitPosition
        sceneView.scene.rootNode.addChildNode(jellyClone)
    }
    
}
