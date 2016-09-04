//
//  CalendarConstants.swift
//  CalendarView
//
//  Created by Michael Li on 7/31/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Foundation

enum CalendarMonth: Int {
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    
    var string: String {
        switch self {
        case January:
            return "January"
        case February:
            return "February"
        case March:
            return "March"
        case April:
            return "April"
        case May:
            return "May"
        case June:
            return "June"
        case July:
            return "July"
        case August:
            return "August"
        case September:
            return "September"
        case October:
            return "October"
        case November:
            return "November"
        case December:
            return "December"
        }
    }
    
    var shortString: String {
        switch self {
        case January:
            return "Jan"
        case February:
            return "Feb"
        case March:
            return "Mar"
        case April:
            return "Apr"
        case May:
            return "May"
        case June:
            return "Jun"
        case July:
            return "Jul"
        case August:
            return "Aug"
        case September:
            return "Sep"
        case October:
            return "Oct"
        case November:
            return "Nov"
        case December:
            return "Dec"
        }
    }
    
}

enum CalendarWeek: Int {
    case Sunday = 0
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var string: String {
        switch self {
    
        case Monday:
            return "Monday"
        case Tuesday:
            return "Tuesday"
        case Wednesday:
            return "Wednesday"
        case Thursday:
            return "Thursday"
        case Friday:
            return "Friday"
        case Saturday:
            return "Saturday"
        case Sunday:
            return "Sunday"
        }
    }
    
    var shortString: String {
        switch self {
        case Monday:
            return "Mon"
        case Tuesday:
            return "Tue"
        case Wednesday:
            return "Wed"
        case Thursday:
            return "Thu"
        case Friday:
            return "Fri"
        case Saturday:
            return "Sat"
        case Sunday:
            return "Sun"
        }
    }
}