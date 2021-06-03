//
//  SKButton.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-11.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import SpriteKit

class SKButton: SKSpriteNode {

enum SKButtonActionType: Int {
    case TouchUpInside = 1,
    TouchDown, TouchUp
}

var label: SKLabelNode

required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
}

init() {
    self.label = SKLabelNode(fontNamed: "ARCADECLASSIC");
    let buttonSize = CGSize(width: 200, height: 100)
    super.init(texture: nil, color: UIColor.white, size: buttonSize)
    isUserInteractionEnabled = true
    
    //Creating and adding a blank label, centered on the button
    self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center;
    self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center;
    addChild(self.label)
    
    // Adding this node as an empty layer. Without it the touch functions are not being called
    // The reason for this is unknown when this was implemented...?
    let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: buttonSize)
    bugFixLayerNode.position = self.position
    addChild(bugFixLayerNode)
    
}

/**
 * Taking a target object and adding an action that is triggered by a button event.
 */
func setButtonAction(target: AnyObject, triggerEvent event:SKButtonActionType, action:Selector) {
    
    switch (event) {
    case .TouchUpInside:
        targetTouchUpInside = target
        actionTouchUpInside = action
    case .TouchDown:
        targetTouchDown = target
        actionTouchDown = action
    case .TouchUp:
        targetTouchUp = target
        actionTouchUp = action
    }
    
}

/*
 New function for setting text. Calling function multiple times does
 not create a ton of new labels, just updates existing label.
 You can set the title, font type and font size with this function
 */

func setButtonLabel(title: NSString, font: String, fontSize: CGFloat) {
    self.label.text = title as String
    self.label.fontSize = fontSize
    self.label.fontName = font
}

var disabledTexture: SKTexture?
var actionTouchUpInside: Selector?
var actionTouchUp: Selector?
var actionTouchDown: Selector?
weak var targetTouchUpInside: AnyObject?
weak var targetTouchUp: AnyObject?
weak var targetTouchDown: AnyObject?

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown)) {
        UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
    }
}

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch: AnyObject! = touches.first
    let touchLocation = touch.location(in: parent!)
}

override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)
        
        if (frame.contains(touchLocation) ) {
            UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
        }
        
    }
    
    if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
        UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
    }
}

}
