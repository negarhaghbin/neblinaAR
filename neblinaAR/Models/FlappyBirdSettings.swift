//
//  FlappyBirdSettings.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class FlappyBirdSettings: Object {
    @objc dynamic var speed : Double = 1
    @objc dynamic var sensitivity : Double = 1
    
    func add(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    func setSpeed(newSpeed: Double){
        let realm = try! Realm()
        try! realm.write {
            self.speed = newSpeed
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
            self.sensitivity = 1
        }
    }
    
    class func get() -> FlappyBirdSettings{
        let realm = try! Realm()
        return realm.objects(FlappyBirdSettings.self).first!
    }
}
