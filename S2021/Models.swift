//
//  Models.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Transaction Model
struct Transaction: Identifiable, Codable {
    let id = UUID()
    let amount: Double
    let description: String
    let category: TransactionCategory
    let date: Date
    let type: TransactionType
    
    enum TransactionType: String, CaseIterable, Codable {
        case income = "income"
        case expense = "expense"
        case saving = "saving"
    }
    
    enum TransactionCategory: String, CaseIterable, Codable {
        case salary = "Salary"
        case groceries = "Groceries"
        case entertainment = "Entertainment"
        case transport = "Transport"
        case savings = "Savings"
        case bonus = "Bonus"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .salary: return "dollarsign.circle.fill"
            case .groceries: return "cart.fill"
            case .entertainment: return "gamecontroller.fill"
            case .transport: return "car.fill"
            case .savings: return "piggybank.fill"
            case .bonus: return "gift.fill"
            case .other: return "questionmark.circle.fill"
            }
        }
    }
}

// MARK: - Saving Goal Model
struct SavingGoal: Identifiable, Codable {
    let id = UUID()
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var createdDate: Date
    var targetDate: Date?
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    var isCompleted: Bool {
        currentAmount >= targetAmount
    }
}

// MARK: - App Data Manager
class AppDataManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var savingGoals: [SavingGoal] = []
    @Published var monthlyGoal: Double = 1000.0
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        // Start with empty data for new users
        transactions = []
        savingGoals = []
    }
    
    // MARK: - Transaction Methods
    func addTransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
    }
    
    func addExpense(amount: Double, description: String, category: Transaction.TransactionCategory) {
        let transaction = Transaction(amount: -abs(amount), description: description, category: category, date: Date(), type: .expense)
        addTransaction(transaction)
    }
    
    func addSaving(amount: Double, description: String) {
        let transaction = Transaction(amount: amount, description: description, category: .savings, date: Date(), type: .saving)
        addTransaction(transaction)
    }
    
    // MARK: - Goal Methods
    func addGoal(_ goal: SavingGoal) {
        savingGoals.append(goal)
    }
    
    func updateGoal(_ goal: SavingGoal) {
        if let index = savingGoals.firstIndex(where: { $0.id == goal.id }) {
            savingGoals[index] = goal
        }
    }
    
    func addFundsToGoal(goalId: UUID, amount: Double) {
        if let index = savingGoals.firstIndex(where: { $0.id == goalId }) {
            savingGoals[index].currentAmount += amount
            
            // Also add as a transaction
            let transaction = Transaction(
                amount: amount,
                description: "Added to \(savingGoals[index].name)",
                category: .savings,
                date: Date(),
                type: .saving
            )
            addTransaction(transaction)
        }
    }
    
    func deleteGoal(goalId: UUID) {
        savingGoals.removeAll { $0.id == goalId }
    }
    
    // MARK: - Statistics
    var totalSavings: Double {
        transactions.filter { $0.type == .saving }.reduce(0) { $0 + $1.amount }
    }
    
    var monthlyProgress: Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let monthlyTransactions = transactions.filter { transaction in
            let transactionMonth = Calendar.current.component(.month, from: transaction.date)
            let transactionYear = Calendar.current.component(.year, from: transaction.date)
            return transactionMonth == currentMonth && transactionYear == currentYear
        }
        
        let monthlySavings = monthlyTransactions.filter { $0.type == .saving }.reduce(0) { $0 + $1.amount }
        return min(monthlySavings / monthlyGoal, 1.0)
    }
    
    var monthlyExpenses: Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let monthlyTransactions = transactions.filter { transaction in
            let transactionMonth = Calendar.current.component(.month, from: transaction.date)
            let transactionYear = Calendar.current.component(.year, from: transaction.date)
            return transactionMonth == currentMonth && transactionYear == currentYear
        }
        
        return monthlyTransactions.filter { $0.type == .expense }.reduce(0) { $0 + abs($1.amount) }
    }
    
    func resetProgress() {
        transactions.removeAll()
        savingGoals.removeAll()
        // Keep data empty after reset
    }
}

// MARK: - Color Extensions
extension Color {
    static let nestFlowPrimary = Color(hex: "#1A1C28")
    static let nestFlowAccent = Color(hex: "#F7B500")
    static let nestFlowSecondary = Color(hex: "#F05A28")
    static let nestFlowTextPrimary = Color.white
    static let nestFlowTextSecondary = Color(hex: "#D8D8D8")
    static let nestFlowCard = Color(hex: "#2A2C39")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
