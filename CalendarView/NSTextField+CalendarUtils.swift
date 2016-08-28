//
//  NSTextField+CalendarUtils.swift
//  CalendarView
//
//  Created by Michael Li on 8/18/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

extension NSTextField {
    
    func setupLabel() {
        self.bezeled = false
        self.drawsBackground = false
        self.editable = false
        self.selectable = false
    }
    
}