//
//  People.swift
//  PerfectTemplate
//
//  Created by 王前 on 2018/8/30.
//

public struct People: Codable {
    
    public var name: String
    public var age: Int
    
    init() {
        self.init(name: "", age: 0)
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
