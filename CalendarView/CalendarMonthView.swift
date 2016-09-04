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
            
            Swift.print(date)
            
            let rowHeight = self.frame.height/CGFloat(row)
            
            row = CalendarManager.numberOfWeeksIn(date) - 1
            
            
            
            self.frame.size.height = rowHeight * CGFloat(row)
            
            let columnWidth = self.frame.width/CGFloat(column)
            let calendarRowHeight = self.frame.height/CGFloat(row)
            
            var day = CalendarManager.startingSundayFor(date)
            
            
             for y in 0..<row {
                if y == views.count {
                    views.append([])
                }
                
                for x in 0..<column {
                    
                    if views[y][safe: x] == nil {
                        views[y].append(CalendarDayView(frame: NSRect(x: CGFloat(x) * columnWidth, y: CGFloat(y) * calendarRowHeight, width: columnWidth, height: calendarRowHeight)))
                        self.addSubview(views[y][x])
                    }
                    
                    let view = views[y][x]
                    
                    if view.superview == nil {
                       self.addSubview(view)
                    }
                    
                    view.date = day
                    
                    day = CalendarManager.next(day)
                }
            }
            
            for y in row..<views.count {
                for x in 0..<column {
                    views[y][x].removeFromSuperview()
                }
            }
            
            let startDate = NSCalendar.currentCalendar().dateFromComponents(views[0][0].date!)!
            let endDate = NSCalendar.currentCalendar().dateFromComponents(views[row - 1][column - 1].date!)!
            
            CalendarEventManager.defaultManager.preloadEventsFor(date, startDate: startDate , endDate: endDate)
            
            needsDisplay = true
        }
    }
    
    var column = 7
    var row = 5
    
    var views = [[CalendarDayView]]()
    
    var rowHeight: CGFloat! {
        didSet {
            self.frame.size.height = (CGFloat(CalendarManager.numberOfWeeksIn(date)) - 1) * rowHeight
            
        }
    }
    
    override var frame: NSRect {
        didSet {
            for (index, row) in views.enumerate() {
                for view in row {
                    
                    var newFrame = view.frame
                    
                    newFrame.size.width = frame.width/CGFloat(column)
                    if let weekday = view.date?.weekday {
                        newFrame.origin.x = frame.width/CGFloat(column) * CGFloat(weekday - 1)
                    }
                    
                    
                    newFrame.origin.y = rowHeight * CGFloat(index)
                    newFrame.size.height = rowHeight
                    
                    view.frame = newFrame
                }
            }
            
            needsDisplay = true
        }
    }
    
    var calendarDateArray: [CalendarDateComponents] = []
    
    
    let color = NSColor(calibratedRed: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), green: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), blue: (CGFloat(arc4random())/CGFloat(UINT32_MAX)), alpha: 1.0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setDate(newDate: CalendarDateComponents) {
        self.date = newDate
    }
    
    required init(newCalendarDate: CalendarDateComponents, frameRect: CGRect, calendarRowHeight: CGFloat) {
        
        
        date = newCalendarDate
        
        
        rowHeight = calendarRowHeight
        
        super.init(frame: frameRect)
        
        row = CalendarManager.numberOfWeeksIn(newCalendarDate) - 1
        
        self.frame.size.height = calendarRowHeight * CGFloat(row)
        
        let columnWidth = frameRect.width/CGFloat(column)
        
        
        var day = CalendarManager.startingSundayFor(date)
        
        for y in 0..<row {
            views.append([])
            for x in 0..<column {
                let view = CalendarDayView(frame: NSRect(x: CGFloat(x) * columnWidth, y: CGFloat(y) * calendarRowHeight, width: columnWidth, height: calendarRowHeight))
                view.date = day
                
                day = CalendarManager.next(day)
                
                views[y].append(view)
                self.addSubview(view)
            }
        }
        
        
        let startDate = NSCalendar.currentCalendar().dateFromComponents(views[0][0].date!)!
        let endDate = NSCalendar.currentCalendar().dateFromComponents(views[row - 1][column - 1].date!)!
            
        CalendarEventManager.defaultManager.preloadEventsFor(date, startDate: startDate , endDate: endDate)
            
        
        
        //self.date = newCalendarDate
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
        
        
        
        path.stroke()
        
    }
    
    override var flipped: Bool {
        return true
    }
    
}
