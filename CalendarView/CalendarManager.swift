//
//  CalendarManager.swift
//  CalendarView
//
//  Created by Michael Li on 8/17/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Cocoa

struct CalendarDateComponents {
    var month: CalendarMonth
    var year: Int
    
    var description: String {
        get {
            return month.string + ", " + String(year)
        }
    }
}

class CalendarManager {

    var calendar : NSCalendar = NSCalendar.currentCalendar()
    
    var currentDateComponents: CalendarDateComponents
    
    var selectedDateComponents: CalendarDateComponents
    
    init() {
        let todayDateComponent = calendar.components([.Day, .Month, .Year, .Weekday], fromDate: NSDate())
        
        currentDateComponents = CalendarDateComponents(month: CalendarMonth(rawValue: todayDateComponent.month)!, year: todayDateComponent.year)
        
        selectedDateComponents = currentDateComponents
    }
    
    func previousMonth() {
        if selectedDateComponents.month == .January {
            selectedDateComponents.month = .December
            selectedDateComponents.year -= 1
        }
        else {
            selectedDateComponents.month = CalendarMonth(rawValue: selectedDateComponents.month.rawValue - 1)!
        }
    }
    
    func nextMonth() {
        if selectedDateComponents.month == .December {
            selectedDateComponents.year += 1
            selectedDateComponents.month = .January
        }
        else {
            selectedDateComponents.month = CalendarMonth(rawValue: selectedDateComponents.month.rawValue + 1)!
        }
    }
    
    
    //Class Helper functions
    
    //This function returns the number of weeks excluding the last week, unless the last day of the month ends on Saturday
    class func numberOfWeeksIn(calendarDate: CalendarDateComponents) -> Int{
        
        let month = calendarDate.month
        let year = calendarDate.year
        
        let calendar = NSCalendar.currentCalendar()
        
        let dateComponents = NSDateComponents()
        dateComponents.month = month.rawValue
        dateComponents.year = year
        dateComponents.day = 1
        
        let date = calendar.dateFromComponents(dateComponents)!
        let weekday = calendar.component(.Weekday, fromDate: date)
        
        let numberOfDays = weekday + CalendarManager.numberOfDaysInMonth(calendarDate)
        
        return Int(ceil(Double(numberOfDays)/7.0))
    }
    
    class func numberOfDaysInMonth(calendarDate: CalendarDateComponents) -> Int {
        
        let month = calendarDate.month
        let year = calendarDate.year
        
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        
        if month == .February {
            if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
                return 29
            }
            else {
                return 28
            }
        }
        else {
            return days[month.rawValue - 1]
        }
    }
    
    class func nextMonth(calendarDate: CalendarDateComponents) -> CalendarDateComponents {
        var nextMonth = calendarDate
        
        if nextMonth.month == .December {
            nextMonth.year += 1
            nextMonth.month = .January
        }
        else {
            nextMonth.month = CalendarMonth(rawValue: nextMonth.month.rawValue + 1)!
        }
        
        return nextMonth
    }
    
    class func prevMonth(calendarDate: CalendarDateComponents) -> CalendarDateComponents {
        var prevMonth = calendarDate
        
        if prevMonth.month == .January {
            prevMonth.month = .December
            prevMonth.year -= 1
        }
        else {
            prevMonth.month = CalendarMonth(rawValue: prevMonth.month.rawValue - 1)!
        }
        
        return prevMonth
        
    }
    
    class func monthAfter(months: Int, calendarDate: CalendarDateComponents) -> CalendarDateComponents {
        var date = calendarDate
        
        for _ in 0..<months {
            date = CalendarManager.nextMonth(date)
        }
        
        return date
    }
    
    class func monthBefore(months: Int, calendarDate: CalendarDateComponents) -> CalendarDateComponents {
        var date = calendarDate
        
        for _ in 0..<months {
            date = CalendarManager.prevMonth(date)
        }
        
        return date
    }
    
}
