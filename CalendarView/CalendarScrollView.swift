//
//  CalendarScrollView.swift
//  CalendarView
//
//  Created by Michael Li on 7/23/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa
import CoreGraphics

protocol CalendarScrollViewDelegate {
    func scrollViewDidScroll(scrollView: CalendarScrollView, event: NSEvent) -> Bool
    func scrollDidEnd(scrollView: CalendarScrollView, deltaY: CGFloat)
    
    func momentumScrollingDidStart(scrollView: CalendarScrollView, deltaY: CGFloat)
    func momentumScrollingDidEnd(scrollView: CalendarScrollView)
}

extension CalendarScrollViewDelegate {
    func scrollDidEnd(scrollView: CalendarScrollView, deltaY: CGFloat) {}
    
    func momentumScrollingDidStart(scrollView: CalendarScrollView, deltaY: CGFloat) {}
    
    func momentumScrollingDidEnd(scrollView: CalendarScrollView) {}
}

class CalendarScrollView: NSScrollView {
    
    var deltaY : CGFloat = 0.0
    var delegate: CalendarScrollViewDelegate? = nil

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        if theEvent.phase == .Began {
            //self.stopAnimation()
        }
        
        if theEvent.phase == .Changed {
            deltaY = theEvent.deltaY
            if delegate?.scrollViewDidScroll(self, event: theEvent) == false {
               return
            }
        }
        
        if theEvent.phase == .Ended {
            delegate?.scrollDidEnd(self, deltaY: deltaY)
        }
        else if theEvent.momentumPhase == .Began {
            delegate?.momentumScrollingDidStart(self, deltaY: theEvent.deltaY)
        }
        else if theEvent.momentumPhase == .Changed {
//            
//            let direction = theEvent.deltaY < 0 ? -1.0 : 1.0
//            let newEvent = CGEventCreateCopy(theEvent.CGEvent)
//            
//            
//            //Not in documentation, but reverse engineering shows that raw value 93 is delta y in NSEvent
//            let deltaY = CGEventGetDoubleValueField(newEvent, CGEventField(rawValue: 93)!) - deltaYChange * direction
//            
//            
//            
//            CGEventSetDoubleValueField(newEvent, CGEventField(rawValue: 93)!, deltaY)
//            let event = NSEvent(CGEvent: newEvent!)!
//            
//            Swift.print(event.deltaY)
//            Swift.print("------------")
//            
//            deltaYChange += 0.1
//            
            //super.scrollWheel(event)
        }
        else {
            super.scrollWheel(theEvent)
        }
//        super.scrollWheel(theEvent)
    }
    
    func animateToY(y: CGFloat) {
        var newOrigin = self.contentView.bounds.origin
        newOrigin.y = y
        
        self.animateToPoint(newOrigin)
    }
    
    func animateToPoint(point: CGPoint) {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.currentContext().duration = 0.2
        
        NSAnimationContext.currentContext().completionHandler = { _ in
            self.delegate?.momentumScrollingDidEnd(self)
        }
        
        self.contentView.animator().setBoundsOrigin(point)
        
        NSAnimationContext.endGrouping()
    }
    
    func stopAnimation() {
        NSAnimationContext.beginGrouping()
        
        NSAnimationContext.currentContext().duration = 0.01
        self.contentView.animator().setBoundsOrigin(self.contentView.bounds.origin)
        
        NSAnimationContext.endGrouping()
    }
    
    override func touchesEndedWithEvent(event: NSEvent) {
    }
    
    override var flipped: Bool {
        get {
            return true
        }
    }
    
}
