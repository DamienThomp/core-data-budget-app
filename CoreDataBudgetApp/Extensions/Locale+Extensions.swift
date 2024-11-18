//
//  Locale+Extensions.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-18.
//

import Foundation

extension Locale {

    var currencyCode: String {
        self.currency?.identifier ?? "CAD"
    }
}
