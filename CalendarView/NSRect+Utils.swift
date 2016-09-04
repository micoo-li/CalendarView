//
//  NSRect+Utils.swift
//  CalendarView
//
//  Created by Michael Li on 9/4/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Foundation

extension NSRect {
    var center: CGPoint {
        return CGPointMake(NSMidX(self), NSMidY(self))
    }
}

