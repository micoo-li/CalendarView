//
//  CalendarDayView.swift
//  CalendarView
//
//  Created by Michael Li on 8/27/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import EventKit
import Cocoa

class CalendarDayView: NSView {
    
    //MARK: Constants
    
    let headerSpacing: CGFloat = 26.0
    let eventSpacing: CGFloat = 20.0
    
    
    let eventBackgroundColor = NSColor(red: 212.0/255.0, green: 221.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    
    let dayField: NSTextField = NSTextField()
    
    var date: NSDateComponents? {
        didSet {
            if let date = date {
                
                if date.day == 1 {
                    let attrStr = NSMutableAttributedString(string: "\(CalendarMonth(rawValue: date.month)!.shortString)  \(date.day)")
                    attrStr.addAttribute(NSForegroundColorAttributeName, value: NSColor.blackColor(), range: NSRange.init(location: 0, length: 3))
                    dayField.attributedStringValue = attrStr
                    //dayField.stringValue = "\(CalendarMonth(rawValue: date.month)!.shortString) \(date.day)"
                }
                else {
                    dayField.stringValue = String(date.day)
                }
                
                dayField.sizeToFit()
            
                dayField.frame.origin.x = frame.width - 4 - dayField.frame.width
                
            }
            
            needsDisplay = true
            
        }
    }
    
    override var frame: NSRect {
        didSet {
            dayField.frame.origin.x = frame.width - 4 - dayField.frame.width
        }
        
    }
    
    override init(frame frameRect: NSRect) {
        dayField.stringValue = "1"
        dayField.font = NSFont(name: "HelveticaNeue", size: 14.0)
        dayField.sizeToFit()
        dayField.setupLabel()
        
        
        dayField.frame.origin = CGPoint(x: 4, y: 4)
        dayField.textColor = NSColor.blackColor()
        
        super.init(frame: frameRect)
        
        self.addSubview(dayField)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        
        if let date = date {
            if date.month == CalendarManager.defaultManager.todayDateComponent.month &&
                date.day == CalendarManager.defaultManager.todayDateComponent.day &&
                date.year == CalendarManager.defaultManager.todayDateComponent.year {
                
                dayField.textColor = NSColor.whiteColor()
                
                //Change to center circle later
                let circleRadius: CGFloat = 9.0
                
                var circleFrame: NSRect = NSRect()
                
                if date.day != 1 {
                    let circleCenter = dayField.frame.center
                    
                    circleFrame.origin = CGPoint(x: circleCenter.x - circleRadius, y: circleCenter.y - circleRadius + 2)
                    circleFrame.size = CGSize(width: circleRadius * 2, height: circleRadius * 2)
                    
                }
                else {
                    //Can't put circle in the center of the dayField if it is 1 as there's the month in front of it
                    //Probably will just hardcode where the circle is drawn instead
                    
                    circleFrame = NSRect(x: dirtyRect.width - circleRadius * 2 - 4, y: 4, width: circleRadius * 2, height: circleRadius * 2)
                }
                
                
                let circle = NSBezierPath(ovalInRect: circleFrame)
                
                NSColor(red: 233.0/255.0, green: 63.0/255.0, blue: 51.0/255.0, alpha: 1.0).setFill()
                
                circle.fill()
                
            }
            else {
                dayField.textColor = NSColor.blackColor()
            }
        }
        
        let events = CalendarEventManager.defaultManager.eventsFor(date!)
        
        
        for (index, event) in events.enumerate() {
            
            eventBackgroundColor.setFill()
            let eventFrame = NSRect(x: 8, y: CGFloat(index) * eventSpacing + headerSpacing - 2, width: dirtyRect.width - 8*2, height: eventSpacing - 2)
            NSRectFill(eventFrame)
            
            var eventStr = NSAttributedString(string: event.title)
            
            var dropped = false
            
            var eventStrWidth = eventStr.size().width
            
            while eventStrWidth > dirtyRect.width - 14*2 {
                dropped = true
                eventStr = NSAttributedString(string: String(eventStr.string.characters.dropLast()))
                eventStrWidth = NSAttributedString(string: eventStr.string + "...").size().width
            }
            
            if dropped == true {
                eventStr = NSAttributedString(string: eventStr.string + "...")
            }
            
            eventStr.drawAtPoint(NSMakePoint(14 + 0.5, CGFloat(index) * eventSpacing + headerSpacing + 0.5))
            
        }
    
    }
    

    
    override var flipped: Bool {
        return true
    }
    
    override func mouseDown(theEvent: NSEvent) {
    }
}
