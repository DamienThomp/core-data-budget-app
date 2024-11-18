//
//  String+Extensions.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-17.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
