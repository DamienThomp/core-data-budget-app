//
//  BudgetViewModelTests.swift
//  CoreDataBudgetAppTests
//
//  Created by Damien L Thompson on 2024-11-23.
//

import XCTest
import CoreData
@testable import CoreDataBudgetApp

final class BudgetViewModelTests: XCTestCase {

    var viewModel: BudgetViewModel!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        let persistentContainer = CoreDataProvider(inMemory: true)

        context = persistentContainer.context
        viewModel = BudgetViewModel(context: context)
    }

    override func tearDown() {

        viewModel = nil
        context = nil
        super.tearDown()
    }

    func testFetchBudgets_noBudgets_returnsEmptyArray() {
        viewModel.fetchBudgets()

        XCTAssertTrue(viewModel.budgets.isEmpty, "Expected no budgets, but got \(viewModel.budgets.count) budgets.")
    }

    func testFetchBudgets_withBudgets_returnsBudgets() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        try? context.save()

        viewModel.fetchBudgets()

        XCTAssertEqual(viewModel.budgets.count, 1, "Expected 1 budget, but got \(viewModel.budgets.count).")
        XCTAssertEqual(viewModel.budgets.first?.title, "Test Budget", "Fetched budget title doesn't match.")
    }

    // MARK: - Test saveBudget
    func testSaveBudget_savesBudgetSuccessfully() {
        viewModel.saveBudget(with: "Test Budget", for: 100.0)

        XCTAssertEqual(viewModel.budgets.count, 1, "Expected 1 budget, but got \(viewModel.budgets.count).")
        XCTAssertEqual(viewModel.budgets.first?.title, "Test Budget", "Budget title does not match.")
        XCTAssertEqual(viewModel.budgets.first?.amount, 100.0, "Budget amount does not match.")
    }

    // MARK: - Test deleteBudget
    func testDeleteBudget_deletesBudgetSuccessfully() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        try? context.save()
        viewModel.fetchBudgets()

        viewModel.deleteBudget(at: IndexSet(integer: 0))

        XCTAssertTrue(viewModel.budgets.isEmpty, "Expected no budgets after deletion, but got \(viewModel.budgets.count).")
    }

    // MARK: - Test budgetExists
    func testBudgetExists_whenBudgetExists_returnsTrueAndSetsErrorMessage() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        try? context.save()

        let result = viewModel.budgetExists(title: "Test Budget")

        XCTAssertTrue(result, "Expected budget to exist, but it doesn't.")
        XCTAssertEqual(viewModel.errorMessage, "Budget already exists for this title.", "Error message doesn't match.")
    }

    func testBudgetExists_whenBudgetDoesNotExist_returnsFalseAndNoErrorMessage() {

        let result = viewModel.budgetExists(title: "Non-Existent Budget")

        XCTAssertFalse(result, "Expected budget to not exist, but it does.")
        XCTAssertNil(viewModel.errorMessage, "Error message should not be set when budget does not exist.")
    }

    // MARK: - Test fetchExpense
    func testFetchExpense_noExpenses_returnsEmptyArray() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        try? context.save()

        viewModel.fetchExpense(for: budget)

        XCTAssertTrue(viewModel.expenses.isEmpty, "Expected no expenses, but got \(viewModel.expenses.count).")
    }

    func testFetchExpense_withExpenses_returnsExpenses() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        let expense = Expense(context: context)
        expense.title = "Test Expense"
        expense.amount = 50.0
        expense.budget = budget
        try? context.save()

        viewModel.fetchExpense(for: budget)

        XCTAssertEqual(viewModel.expenses.count, 1, "Expected 1 expense, but got \(viewModel.expenses.count).")
        XCTAssertEqual(viewModel.expenses.first?.title, "Test Expense", "Expense title doesn't match.")
    }

    // MARK: - Test saveExpense
    func testSaveExpense_addsExpenseToBudget() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        try? context.save()

        viewModel.saveExpense(for: budget, title: "Test Expense", amount: 50.0)

        XCTAssertEqual(viewModel.expenses.count, 1, "Expected 1 expense, but got \(viewModel.expenses.count).")
        XCTAssertEqual(viewModel.expenses.first?.title, "Test Expense", "Expense title doesn't match.")
        XCTAssertEqual(viewModel.expenses.first?.amount, 50.0, "Expense amount doesn't match.")
    }

    // MARK: - Test deleteExpense
    func testDeleteExpense_removesExpenseSuccessfully() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()

        let expense = Expense(context: context)
        expense.title = "Test Expense"
        expense.amount = 50.0
        expense.dateCreated = Date()

        expense.budget = budget
        try? context.save()

        viewModel.fetchExpense(for: budget)

        viewModel.deleteExpense(at: IndexSet(integer: 0), for: budget)

        XCTAssertTrue(viewModel.expenses.isEmpty, "Expected no expenses after deletion, but got \(viewModel.expenses.count).")
    }

    // MARK: - Test totalExpenses
    func testTotalExpenses_calculatesCorrectly() {

        let budget = Budget(context: context)
        budget.title = "Test Budget"
        budget.amount = 100.0
        budget.dateCreated = Date()
        
        let expense1 = Expense(context: context)
        expense1.title = "Expense 1"
        expense1.amount = 50.0
        expense1.budget = budget

        let expense2 = Expense(context: context)
        expense2.title = "Expense 2"
        expense2.amount = 25.0
        expense2.budget = budget

        try? context.save()

        viewModel.fetchExpense(for: budget)

        XCTAssertEqual(viewModel.totalExpenses, 75.0, "Total expenses should be 75.0, but got \(viewModel.totalExpenses).")
    }
}
