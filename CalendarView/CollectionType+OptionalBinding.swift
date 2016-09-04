//
//  Indexable+OptionalBinding.swift
//  CalendarView
//
//  Created by Michael Li on 8/31/16.
//  Copyright © 2016 Michael Li. All rights reserved.
//

import Foundation

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}