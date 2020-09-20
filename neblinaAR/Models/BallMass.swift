//
//  BallMass.swift
//  neblinaAR
//
//  Created by Negar on 2020-09-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation
import RealmSwift

class BallMass: Object {
    @objc dynamic var level1 : Double = 0.049
    @objc dynamic var level2 : Double = 0.045
    @objc dynamic var level3 : Double = 0.040
    @objc dynamic var level4 : Double = 0.029
    @objc dynamic var level5 : Double = 0.040
    @objc dynamic var level6 : Double = 0.040
    
    func add(){
        let realm = try! Realm()
        if realm.objects(BallMass.self).count < 1{
            try! realm.write {
                realm.add(self)
            }
        }
    }
    
    func changeMass(level: Int, newMass:Double){
        if level == 1{
            let realm = try! Realm()
            try! realm.write {
                self.level1 = newMass
            }
        }
        else if level == 2{
            let realm = try! Realm()
            try! realm.write {
                self.level2 = newMass
            }
        }
        else if level == 3{
            let realm = try! Realm()
            try! realm.write {
                self.level3 = newMass
            }
        }
        else if level == 4{
            let realm = try! Realm()
            try! realm.write {
                self.level4 = newMass
            }
        }
        else if level == 5{
            let realm = try! Realm()
            try! realm.write {
                self.level5 = newMass
            }
        }
        else if level == 6{
            let realm = try! Realm()
            try! realm.write {
                self.level6 = newMass
            }
        }
    }
    
    func getMass(level:Int) -> Double{
        if level == 1{
            return level1
        }
        else if level == 2{
            return level2
        }
        else if level == 3{
            return level3
        }
        else if level == 4{
            return level4
        }
        else if level == 5{
            return level5
        }
        else if level == 6{
            return level6
        }
        return 0.0
    }
}
