//
//  CalendarMonthView.swift
//  CalendarView
//
//  Created by Michael Li on 7/18/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

class CalendarMonthView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        
        NSColor(calibratedWhite: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), alpha: 1).setFill()
        
        NSRectFill(dirtyRect)
        
        
    }
    
}
