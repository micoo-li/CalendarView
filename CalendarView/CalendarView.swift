//
//  CalendarView.swift
//  CalendarView
//
//  Created by Michael Li on 7/18/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

class CalendarView: NSView {
    
    var calendarScrollView: NSScrollView = NSScrollView
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSetup()
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        initSetup()
    }
    
    convenience init() {
        self.init(frame: NSMakeRect(0, 0, 0, 0))
    }
    
    func initSetup() {
        
        //Set up scroll view
        let calendarScrollView = NSScrollView.init(frame: self.frame)
        
        calendarScrollView.hasVerticalScroller = true
        calendarScrollView.hasHorizontalScroller = false
        
        calendarScrollView.borderType = .NoBorder
  //      calendarScrollView.autoresizingMask = .V
        
        let contentView = NSView.init(frame: NSZeroRect)
        
        var originOffset = CGPointZero
        
        for _ in 0...5 {
            let view = CalendarMonthView.init(frame: NSRect(origin: originOffset, size: calendarScrollView.contentView.frame.size))
            
            originOffset.y += view.frame.size.height
            
            contentView.frame.size.width = view.frame.size.width
            contentView.frame.size.height += view.frame.size.height
            
            contentView.addSubview(view)
        }
        
        calendarScrollView.documentView = contentView
        
        //Setup notifications 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(calendarViewBoundsDidChange), name: NSViewBoundsDidChangeNotification, object: calendarScrollView)
        
        
        self.addSubview(calendarScrollView)
    }
    
    //MARK: Notification methods
   
    func calendarViewBoundsDidChange(notification: NSNotification) {
        print(notification.object)
    }
    
    
}
