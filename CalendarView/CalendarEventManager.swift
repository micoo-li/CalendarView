//
//  CalendarEventManager.swift
//  CalendarView
//
//  Created by Michael Li on 9/2/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa
import EventKit

class CalendarEventManager {
    static let defaultManager = CalendarEventManager()
    
    let calendarStore = EKEventStore()
    
    var dayEvents = [NSDateComponents: [String: EKEvent]]()
    
    init() {
        calendarStore.requestAccessToEntityType(.Event, completion: {
            _, _ in
        })
    }
    
    func preloadEventsFor(calendarMonth: CalendarDateComponents, startDate: NSDate, endDate: NSDate) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let eventsPredicate = self.calendarStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
            let events = self.calendarStore.eventsMatchingPredicate(eventsPredicate)
            
            let calendar = NSCalendar.currentCalendar()
            
            for event in events {
                
                let startEvent = event.startDate
                let endEvent = event.endDate
                
                let startDayComponents = calendar.components([.Day, .Month, .Year], fromDate: startDate)
                
                //Only adding to start day first
                
                if self.dayEvents[startDayComponents] == nil {
                    self.dayEvents[startDayComponents] = [:]
                }
                
                self.dayEvents[startDayComponents]![event.eventIdentifier] = event
                Swift.print("added")
                
                //dayEvents[startDayComponents]
            }    
        })
    }
    
    func eventsFor(day: NSDateComponents) -> [EKEvent] {
        
        if let events = dayEvents[day] {
            return Array(events.values)
        }
        
        else {
            day.hour = 0
            day.minute = 0
            day.second = 0
            
            let startDay = NSCalendar.currentCalendar().dateFromComponents(day)!
            let endDay = startDay.dateByAddingTimeInterval(CalendarManager.secondsInDay - 1)
            
            let eventsPredicate = calendarStore.predicateForEventsWithStartDate(startDay, endDate: endDay, calendars: nil)
            let events = calendarStore.eventsMatchingPredicate(eventsPredicate)
            
            var eventsIdPair = [String: EKEvent]()
            events.forEach { eventsIdPair[$0.eventIdentifier] = $0}
            
            dayEvents[day] = eventsIdPair
            
            return events
        }
    }
    
    
}
