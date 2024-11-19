//
//  BudgetTests.swift
//  CoreDataBudgetAppTests
//
//  Created by Damien L Thompson on 2024-11-18.
//

import XCTest
import CoreData
@testable import CoreDataBudgetApp

final class BudgetTests: XCTestCase {

    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let provider = CoreDataProvider(inMemory: true)
        context = provider.context
    }

    override func tearDownWithError() throws {
        context = nil
    }

    func testExistsWithExistingTitle() throws {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 20
        budget.dateCreated = Date()

        try context.save()

        XCTAssertTrue(Budget.exists(context: context, title: "Test Budget"))
    }

    func testExistsWithNonExistingTitle() throws {
        XCTAssertFalse(Budget.exists(context: context, title: "Non-Existent Budget"))
    }

    func testExistsWithEmptyDatabase() throws {
        XCTAssertFalse(Budget.exists(context: context, title: "Test Budget"))
    }
}
