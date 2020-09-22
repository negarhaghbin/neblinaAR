//
//  BreakoutSettings.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class BreakoutSettings: Object {
    @objc dynamic var isAudioOn : Bool = true
    @objc dynamic var isVisualOn : Bool = true
    @objc dynamic var speed : Double = 1
    @objc dynamic var paddleWidth : Double = 1
    @objc dynamic var sensitivity : Double = 1
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    func setAudioFeedback(newValue: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.isAudioOn = newValue
        }
    }
    
    func setVisualFeedback(newValue: Bool){
        let realm = try! Realm()
        try! realm.write {
            self.isVisualOn = newValue
        }
    }
    
    func setSpeed(newSpeed: Double){
        let realm = try! Realm()
        try! realm.write {
            self.speed = newSpeed
        }
    }
    
    func setPaddleWidth(newWidth: Double){
        let realm = try! Realm()
        try! realm.write {
            self.paddleWidth = newWidth
        }
    }
    
    func setSensitivity(newSensitivity: Double){
        let realm = try! Realm()
        try! realm.write {
            self.sensitivity = newSensitivity
        }
    }
    
    func reset(){
        let realm = try! Realm()
        try! realm.write {
            self.speed = 1
            self.paddleWidth = 1
            self.sensitivity = 1
        }
    }
    
    class func get() -> BreakoutSettings{
        let realm = try! Realm()
        return realm.objects(BreakoutSettings.self).first!
    }
}
