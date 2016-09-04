//
//  NSDateComponents+Hashable.swift
//  CalendarView
//
//  Created by Michael Li on 9/3/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Foundation

extension NSDateComponents {
    
    override public var hashValue: Int {
        return "\(day) \(month) \(year)".hashValue
    }
    
}
