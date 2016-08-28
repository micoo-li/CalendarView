//
//  CalendarMonthView.swift
//  CalendarView
//
//  Created by Michael Li on 7/18/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

class CalendarMonthView: NSView {
    
    var date: CalendarDateComponents! {
        didSet {
            needsDisplay = true
        }
    }
    
    var column = 7
    var row = 5
    
    var rowHeight: CGFloat! {
        didSet {
            self.frame.size.height = CGFloat(CalendarManager.numberOfWeeksIn(date)) * rowHeight
        }
    }
    
    let color = NSColor(calibratedRed: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), green: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), blue: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), alpha: 1.0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(newCalendarDate: CalendarDateComponents, frameRect: CGRect, calendarRowHeight: CGFloat) {
        
        date = newCalendarDate
        rowHeight = calendarRowHeight
        
        super.init(frame: frameRect)
        
        Swift.print(newCalendarDate)
        
        Swift.print(CalendarManager.numberOfWeeksIn(newCalendarDate))
        
        row = CalendarManager.numberOfWeeksIn(newCalendarDate)
        
    
    }
    
    override func drawRect(dirtyRect: NSRect) {
//
//        if month == .January {
//            NSColor.redColor().setFill()
//        }
//        else if month == .February {
//            NSColor.greenColor().setFill()
//        }
//        else if month == .March {
//            NSColor.blueColor().setFill()
//        }
            
        color.setFill()
//
        
        let path = NSBezierPath()
        
        for i in 1..<column {
            let x = CGFloat(i) * round(dirtyRect.size.width/CGFloat(column))
            path.moveToPoint(CGPoint(x: x + 0.5, y: 0 + 0.5))
            path.lineToPoint(CGPoint(x: x + 0.5, y: dirtyRect.size.height + 0.5))
        }
        
        for i in 0..<row {
            let y = CGFloat(i) * round(dirtyRect.size.height/CGFloat(row))
            path.moveToPoint(CGPoint(x: 0 + 0.5, y: y + 0.5))
            path.lineToPoint(CGPoint(x: dirtyRect.size.width + 0.5, y: y + 0.5))
        }
        
        path.lineWidth = 1.0
        
        NSColor(calibratedWhite: 150.0/255.0, alpha: 1.0).setStroke()
        
        
        NSRectFill(dirtyRect)
        
        path.stroke()
        
        
        
        
    }
    
}
