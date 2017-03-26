//
//  Model.swift
//  LearnRxSwift
//
//  Created by Tsung Han Yu on 2017/3/25.
//  Copyright © 2017年 Tsung Han Yu. All rights reserved.
//

import RxDataSources

struct Model {
    
    var name: String
    var age: String
    
    init(_ name:String, _ age:String) {
        self.name = name
        self.age = age
    }
}

extension Model: CustomStringConvertible {
    var description: String {
        return "\(name)'s age is \(age)"
    }
}
