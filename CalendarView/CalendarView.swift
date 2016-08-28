//
//  CalendarView.swift
//  CalendarView
//
//  Created by Michael Li on 7/18/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

class CalendarView: NSView, CalendarScrollViewDelegate {
    
    //MARK: Constants
    //Number of month views preloaded
    //This should be an odd number or else would not work
    let maxMonthsLoaded = 7
    
    let rowsShown = 6
    
    //Scrolling works right now by checking if the user has scrolled through half of the view
    //This variable determines the delta y speed to jump to the other page even if the user hasn't scrolled to half of the page yet
    let minDeltaYToJump: CGFloat = 1.0
    
    //Starts not from 0 but from an arbitrary number, as you cannot add subviews with a negative origin
    //The view will reset its frame origin once scrolling stops
    let startOriginY: CGFloat = 10000.0
    
    let calendarHeaderHeight: CGFloat = 80.0
    
    //Calendar month/year field spacing
    struct Spacing {
        static let monthOriginX: CGFloat = 18.0
        static let monthOriginYFromTop: CGFloat = 18.0
        
        static let weekDayFieldSpacing: CGFloat = 5.0
        static let weekDayFieldFromBottom: CGFloat = 8.0
    }
    
    struct Font {
        static let fontSize: CGFloat = 26.0
        
        static let monthFont = NSFont.init(name: "HelveticaNeue-Bold", size: fontSize)!
        static let yearFont = NSFont.init(name: "HelveticaNeue-Light", size: fontSize)!
    }
    
    //MARK: Properties
    var calendarMonthField: NSTextField = NSTextField()
    var calendarWeekField = [NSTextField]()
    
    var calendarScrollView: CalendarScrollView = CalendarScrollView()
    
    var calendarHeader: NSView = NSView()
    var contentView: CalendarContentView = CalendarContentView()
    var calendarMonthViews: [CalendarMonthView] = []
    
    
    var calendarManager = CalendarManager()
    var startWeek: CalendarWeek = .Sunday
    
    
    //MARK: Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSetup()
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        initSetup()
    }
    
    
    func initSetup() {
        
        //Set up scroll view
        calendarScrollView = CalendarScrollView.init(frame: self.frame)
        
        calendarScrollView.frame.origin.y = calendarHeaderHeight
        calendarScrollView.frame.size.height -= calendarHeaderHeight
        
        //Scroll View frame should be around 80 pixels shorter
        
        calendarScrollView.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        calendarScrollView.hasVerticalScroller = true
        calendarScrollView.verticalScroller?.alphaValue = 0.0
        
        calendarScrollView.hasHorizontalScroller = false
        
        calendarScrollView.borderType = .NoBorder
        calendarScrollView.delegate = self
        
       // calendarScrollView.contentView.copiesOnScroll = false
        calendarScrollView.wantsLayer = true
        calendarScrollView.contentView.wantsLayer = true
        
        let contentSize = CGSize(width: 0, height: startOriginY)
        var originOffset = CGPoint(x: 0, y: startOriginY)
        
        contentView = CalendarContentView.init(frame: NSRect(origin: CGPointZero, size: contentSize))
        contentView.autoresizingMask = [.ViewHeightSizable, .ViewWidthSizable]
        
        contentView.wantsLayer = true
        self.addSubview(calendarScrollView)
        
        
        let startMonth = CalendarManager.monthBefore(maxMonthsLoaded/2, calendarDate: calendarManager.selectedDateComponents)
        
        for i in 0..<maxMonthsLoaded {
            
            let view = CalendarMonthView.init(newCalendarDate: CalendarManager.monthAfter(i, calendarDate:  startMonth), frameRect: NSRect(origin: originOffset, size: calendarScrollView.contentView.frame.size), calendarRowHeight: calendarScrollView.contentView.bounds.size.height/CGFloat(rowsShown))
            
            view.wantsLayer = true
            
            originOffset.y += view.frame.size.height
            
            contentView.frame.size.width = view.frame.size.width
            contentView.frame.size.height += view.frame.size.height
            
            calendarMonthViews.append(view)
            
            contentView.addSubview(view)
        }
        
        
        //Setup notifications
        calendarScrollView.contentView.postsBoundsChangedNotifications = true
        calendarScrollView.contentView.postsFrameChangedNotifications = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contentViewDidResize), name: NSWindowDidResizeNotification, object: self.window)
        
        //Setup contents and view
        calendarScrollView.documentView = contentView
        
        
        
        calendarScrollView.contentView.scrollToPoint(NSPoint(x: 0, y: calendarScrollView.frame.size.height * CGFloat(maxMonthsLoaded/2) + startOriginY))
        
        
        //Add Calendar Header Stuff
        
        var weekOfDay = startWeek
        
        
        for _ in 0..<7 {
            let weekDayField = NSTextField()
            
            weekDayField.stringValue = weekOfDay.shortString
            weekDayField.setupLabel()
            
            weekDayField.sizeToFit()
            
            calendarHeader.addSubview(weekDayField)
            
            weekOfDay = CalendarWeek(rawValue: (weekOfDay.rawValue + 1) % 7)!
            
            calendarWeekField.append(weekDayField)
        }
        
        updateCalendarHeaderLayout()
//
        updateCalendarHeader()
        
        calendarMonthField.setupLabel()
        
        self.addSubview(calendarHeader)
        calendarHeader.addSubview(calendarMonthField)
        
        //Just so it fixes the layout
        contentViewDidResize()
    }
    
    //MARK: Calendar Header Methods
    
    func updateCalendarHeader() {
        //drawing the month/year
        
        calendarMonthField.attributedStringValue = attributedStringForCalendarMonth(calendarManager.selectedDateComponents)
        
        calendarMonthField.sizeToFit()
        
    }
    
    func updateCalendarHeaderLayout() {
        calendarHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: calendarHeaderHeight)
        
        calendarMonthField.frame.origin.x = Spacing.monthOriginX
        
        calendarMonthField.frame.origin.y = calendarHeaderHeight - Spacing.monthOriginYFromTop - Font.fontSize
        
        
        //Drawing the labels for the day of the week
        let viewWidth = self.frame.size.width
        for (index, weekField) in calendarWeekField.enumerate() {
            weekField.frame.origin.y = Spacing.weekDayFieldFromBottom
            weekField.frame.origin.x = viewWidth/7 * CGFloat(index + 1) - weekField.frame.width - Spacing.weekDayFieldSpacing
            
        }
    }
    
    func attributedStringForCalendarMonth(calendarDateComponents: CalendarDateComponents) -> NSAttributedString {
        
        let calendarMonth = calendarDateComponents.month
        let year = calendarDateComponents.year
        
        let monthString = calendarMonth.string
        let attrStr = NSMutableAttributedString(string: "\(monthString) \(year)")
        
        attrStr.setAttributes([NSFontAttributeName : Font.monthFont], range: NSRange.init(location: 0, length: monthString.characters.count))
        attrStr.setAttributes([NSFontAttributeName : Font.yearFont], range: NSRange.init(location: monthString.characters.count, length: attrStr.string.characters.count - monthString.characters.count))
        
        
        
        return attrStr
    }
    
    //MARK: Notification methods
   
    func contentViewDidResize() {
        let newHeight = calendarScrollView.contentView.frame.size.height
        
        var originY = startOriginY
        
        for (index, calendarMonthView) in calendarMonthViews.enumerate() {
            calendarMonthView.frame.origin.y = originY
            
            
            //calendarMonthView.frame.size.height = newHeight
            calendarMonthView.rowHeight = calendarScrollView.contentView.bounds.size.height/CGFloat(rowsShown)
            
            calendarMonthView.frame.size.width = calendarScrollView.contentView.frame.size.width
            originY += calendarMonthView.frame.height
        }
        
        contentView.frame.size.height = newHeight * CGFloat(maxMonthsLoaded) + startOriginY
        
        calendarScrollView.contentView.setBoundsOrigin(calendarMonthViews[calendarMonthViews.count/2].frame.origin)
        
        updateCalendarHeaderLayout()
        
    }
    
    // MARK: Calendar Scroll View Delegate
    
    func viewClosestTo(frame: CGRect) -> CalendarMonthView {
//        let currentY = frame.origin.y
//        
//        let centerViewY = calendarMonthViews[calendarMonthViews.count/2].frame.origin.y
//        
//        Swift.print(calendarMonthViews[calendarMonthViews.count/2].frame.origin.y)
//        Swift.print(calendarMonthViews[calendarMonthViews.count/2].frame.height)
//        Swift.print(currentY)
//        
//        
//        if currentY < centerViewY {
//            
//        }
//        else {
//           let diff = currentY - centerViewY
//            
//            if diff < calendarMonthViews[calendarMonthViews.count/2].frame.height/2 {
//                //return calendarMonthViews[calendarMonthViews.count/2]
//            }
//        }
//        
//        Swift.print("=====")
       
        var maxHeight:CGFloat = 0.0
        var viewToScroll: CalendarMonthView!
        
        for monthView in calendarMonthViews {
            let intersectionHeight = CGRectIntersection(calendarScrollView.documentVisibleRect, monthView.frame).height
            if maxHeight < intersectionHeight {
                maxHeight = intersectionHeight
                viewToScroll = monthView
            }
        }
        
        return viewToScroll
        
    }
    
    func scrollDidEnd(scrollView: CalendarScrollView, deltaY: CGFloat) {
        
        var closestView = viewClosestTo(scrollView.documentVisibleRect)
        
        if deltaY > 1.0 {
            closestView = calendarMonthViews[calendarMonthViews.indexOf(closestView)! - 1]
        }
        else if deltaY < -1.0 {
            closestView = calendarMonthViews[calendarMonthViews.indexOf(closestView)! + 1]
        }
        
        calendarManager.selectedDateComponents = closestView.date
        updateCalendarHeader()
    
        calendarScrollView.animateToY(closestView.frame.origin.y)
    }
    
    func momentumScrollingDidStart(scrollView: CalendarScrollView, deltaY: CGFloat) {
    }
    
    func momentumScrollingDidEnd(scrollView: CalendarScrollView) {
        
        let newView = viewClosestTo(scrollView.bounds)
        
        if let viewIndex = calendarMonthViews.indexOf(newView) {
            if viewIndex < maxMonthsLoaded/2 {
                
                for _ in 0..<maxMonthsLoaded/2 - viewIndex {
                    Swift.print(calendarMonthViews)
                    calendarMonthViews.insert(calendarMonthViews.popLast()!, atIndex: 0)
                    Swift.print(calendarMonthViews)
                    //Call recycle view
                    Swift.print("Bottom to top")
                }
                
            }
            else if viewIndex > maxMonthsLoaded/2 {
                
                for _ in 0..<viewIndex - maxMonthsLoaded/2 {
                    calendarMonthViews.append(calendarMonthViews.removeFirst())
                    Swift.print("Top to bottom")
                }
            }
            
            rearrangeMonthViewFrames()
        }
    }
    
    //This view rearranges the view when its scrolled too low so the top view goes to the bottom
    //And the if its scrolled too high the bottom view goes to the top
    func rearrangeBottomViewToTop() {
        
        let monthView = calendarMonthViews.first!
        
        monthView.frame.origin.y = calendarMonthViews.last!.frame.origin.y + monthView.frame.size.height
        
        
        calendarMonthViews.append(calendarMonthViews.removeFirst())
        
        var pageToScroll = CGFloat(0.0)
        
        while calendarMonthViews.first!.frame.origin.y != startOriginY {
            pageToScroll += 1.0
            for calendarMonthView in calendarMonthViews {
                calendarMonthView.frame.origin.y -= monthView.frame.size.height
            }
        }
     
        calendarScrollView.contentView.setBoundsOrigin(calendarMonthViews[calendarMonthViews.count/2].frame.origin)
    }
    
    func rearrangeMonthViewFrames() {
        var originOffset = CGPoint(x: 0, y: startOriginY)
        
        for view in calendarMonthViews {
            view.frame.origin = originOffset
            originOffset.y += view.frame.size.height
        }
        
        Swift.print(calendarMonthViews)
        calendarScrollView.contentView.setBoundsOrigin(calendarMonthViews[calendarMonthViews.count/2].frame.origin)
        
    }
    
    //MARK: Override methods
    
    override var flipped: Bool {
        get {
            return true
        }
    }
}
