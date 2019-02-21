//
//  Array.swift
//  Instagram
//
//  Created by Fahad Almehawas on 5/14/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//

import Foundation
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
