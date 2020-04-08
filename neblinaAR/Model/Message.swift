//
//  Message.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

final class Message: Codable{
    var id:Int?
    var message:String
    
    init(message:String) {
        self.message = message
    }
}
