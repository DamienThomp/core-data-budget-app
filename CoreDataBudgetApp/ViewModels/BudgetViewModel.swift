//
//  BudgetViewModel.swift
//  CoreDataBudgetApp
//
//  Created by Damien L Thompson on 2024-11-23.
//

import Foundation
import CoreData
import Observation

@Observable
class BudgetViewModel {

    var budgets = [Budget]()
    var expenses = [Expense]()
    var errorMessage: String? = nil

    var totalExpenses: Double {
        expenses.reduce(0) { result, expense in
            return expense.amount + result
        }
    }

    var remaining: Double? {

        guard let budget = expenses.first?.budget else { return nil }

        return budget.amount - totalExpenses
    }

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func budgetExists(title: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<Budget>(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)

        do {
            let result = try context.fetch(fetchRequest)

            if !result.isEmpty {
                errorMessage = "Budget already exists for this title."
            }

            return !result.isEmpty
        } catch {
            return false
        }
    }

    func fetchBudgets() {

        let fetchRequest = NSFetchRequest<Budget>(entityName: "Budget")

        do {
            budgets = try context.fetch(fetchRequest)
        } catch let error as NSError {
            NSLog("Unresolved error fetching budget: \(error), \(error.userInfo)")
            errorMessage = "Unable to load budgets."
        }
    }

    func saveBudget(with title: String, for amount: Double) {

        let budget = Budget(context: context)
        budget.title = title
        budget.amount = amount
        budget.dateCreated = Date()

        do {
            try context.save()
            fetchBudgets()
        } catch let error as NSError {
            NSLog("Unable to save budget: \(error), \(error.userInfo)")
            errorMessage = "Unable to save budget."
        }
    }

    func deleteBudget(at offsets: IndexSet) {

        for index in offsets {
            let budget = budgets[index]
            context.delete(budget)
        }

        do {
            try context.save()
            fetchBudgets()
        } catch let error as NSError {
            NSLog("Unable to delete budget: \(error), \(error.userInfo)")
            errorMessage = "Unable to delete budget."
        }
    }

    func fetchExpense(for budget: Budget) {
        
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        request.predicate = NSPredicate(format: "budget == %@", budget)

        do {
            expenses = try context.fetch(request)
        } catch let error as NSError {
            NSLog("Unable to fetch expenses: \(error), \(error.userInfo)")
            errorMessage = "Unable to fetch expenses."
        }
    }

    func saveExpense(for budget: Budget, title: String, amount: Double) {

        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount
        expense.dateCreated = Date()

        budget.addToExpenses(expense)

        do {
            try context.save()
            fetchExpense(for: budget)
        } catch let error as NSError {
            errorMessage = "Unable to save expense."
            NSLog("Unable to save expense: \(error), \(error.userInfo)")
        }
    }

    func updateExpense(for expense: Expense) {

        guard let budget = expense.budget else {
            print("missing budget")
            return
        }

        do {
            try context.save()
            fetchExpense(for: budget)
        } catch let error as NSError {
            errorMessage = "Unable to update expense."
            NSLog("Unable to update expense: \(error), \(error.userInfo)")
        }
    }

    func deleteExpense(at offsets: IndexSet, for budget: Budget) {

        for index in offsets {
            let expense = expenses[index]
            context.delete(expense)
        }

        do {
            try context.save()
            fetchExpense(for: budget)
        } catch let error as NSError {
            errorMessage = "Unable to delete expense."
            NSLog("Unable to delete expense: \(error), \(error.userInfo)")
        }
    }
}

