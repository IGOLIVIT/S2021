//
//  StatisticsView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataManager: AppDataManager
    @State private var showingResetAlert = false
    @State private var animateCharts = false
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Statistics cards
                statisticsCardsSection
                
                // Expenses by category chart
                expensesCategorySection
                
                // Monthly trend
                monthlyTrendSection
                
                // Reset button
                resetSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Color.nestFlowPrimary.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateCards = true
            }
            withAnimation(.easeInOut(duration: 1.2).delay(0.5)) {
                animateCharts = true
            }
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                dataManager.resetProgress()
            }
        } message: {
            Text("This will remove all your transactions and goals. This action cannot be undone.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Statistics")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.nestFlowTextPrimary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6), value: animateCards)
            
            Text("Analyze your growth and start fresh anytime")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.nestFlowTextSecondary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.2), value: animateCards)
        }
        .padding(.top, 10)
    }
    
    private var statisticsCardsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Savings",
                    value: "$\(Int(dataManager.totalSavings))",
                    icon: "banknote.fill",
                    color: .nestFlowAccent,
                    animate: animateCards
                )
                
                StatCard(
                    title: "This Month",
                    value: "$\(Int(dataManager.monthlyProgress * dataManager.monthlyGoal))",
                    icon: "calendar",
                    color: .nestFlowSecondary,
                    animate: animateCards
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Monthly Expenses",
                    value: "$\(Int(dataManager.monthlyExpenses))",
                    icon: "creditcard.fill",
                    color: .nestFlowSecondary,
                    animate: animateCards
                )
                
                StatCard(
                    title: "Active Goals",
                    value: "\(dataManager.savingGoals.count)",
                    icon: "target",
                    color: .nestFlowAccent,
                    animate: animateCards
                )
            }
        }
    }
    
    private var expensesCategorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expenses by Category")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.nestFlowTextPrimary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.6), value: animateCards)
            
            if expensesByCategory.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    VStack(spacing: 8) {
                        Text("No expenses tracked")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Add some expenses to see category breakdown")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.nestFlowCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.easeInOut(duration: 0.8).delay(0.7), value: animateCards)
            } else {
                VStack(spacing: 12) {
                    ForEach(expensesByCategory, id: \.category) { item in
                        ExpenseCategoryRow(
                            category: item.category,
                            amount: item.amount,
                            percentage: item.percentage,
                            animate: animateCharts
                        )
                    }
                }
                .padding(20)
                .background(Color.nestFlowCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.easeInOut(duration: 0.8).delay(0.7), value: animateCards)
            }
        }
    }
    
    private var monthlyTrendSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Balance Change")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.nestFlowTextPrimary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.8), value: animateCards)
            
            if dataManager.transactions.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    VStack(spacing: 8) {
                        Text("No weekly data")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Add transactions to see weekly trends")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.nestFlowCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.easeInOut(duration: 0.8).delay(0.9), value: animateCards)
            } else {
                VStack(spacing: 16) {
                    HStack {
                        Text("Average Weekly Change")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.nestFlowTextSecondary)
                        
                        Spacer()
                        
                        Text("\(averageWeeklyChange >= 0 ? "+" : "")$\(Int(averageWeeklyChange))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(averageWeeklyChange >= 0 ? .nestFlowAccent : .nestFlowSecondary)
                    }
                    
                    // Simple bar chart representation
                    VStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { week in
                            HStack {
                                Text("Week \(week + 1)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.nestFlowTextSecondary)
                                    .frame(width: 60, alignment: .leading)
                                
                                GeometryReader { geometry in
                                    HStack {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(weeklyAmounts[week] >= 0 ? Color.nestFlowAccent : Color.nestFlowSecondary)
                                            .frame(
                                                width: animateCharts ? geometry.size.width * CGFloat(abs(weeklyData[week])) : 0,
                                                height: 8
                                            )
                                            .animation(.easeInOut(duration: 1.0).delay(Double(week) * 0.2), value: animateCharts)
                                        
                                        Spacer()
                                    }
                                }
                                .frame(height: 8)
                                
                                Text("\(weeklyAmounts[week] >= 0 ? "+" : "")$\(Int(weeklyAmounts[week]))")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.nestFlowTextPrimary)
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(20)
                .background(Color.nestFlowCard)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 30)
                .animation(.easeInOut(duration: 0.8).delay(0.9), value: animateCards)
            }
        }
    }
    
    private var resetSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingResetAlert = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.nestFlowSecondary)
                    
                    Text("Reset Progress")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.nestFlowSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.nestFlowSecondary.opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.nestFlowSecondary, lineWidth: 2)
                )
            }
            
            Text("Start fresh with a clean slate")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.nestFlowTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.6).delay(1.0), value: animateCards)
    }
    
    // MARK: - Computed Properties
    
    private var expensesByCategory: [(category: Transaction.TransactionCategory, amount: Double, percentage: Double)] {
        let expenses = dataManager.transactions.filter { $0.type == .expense }
        let totalExpenses = expenses.reduce(0) { $0 + abs($1.amount) }
        
        guard totalExpenses > 0 else { return [] }
        
        let categoryTotals = Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { transactions in
                transactions.reduce(0) { $0 + abs($1.amount) }
            }
        
        return categoryTotals.map { (category, amount) in
            (category: category, amount: amount, percentage: amount / totalExpenses)
        }
        .sorted { $0.amount > $1.amount }
        .prefix(5)
        .map { $0 }
    }
    
    private var weeklyData: [Double] {
        let maxAmount = weeklyAmounts.max() ?? 1.0
        return weeklyAmounts.map { maxAmount > 0 ? $0 / maxAmount : 0.0 }
    }
    
    private var weeklyAmounts: [Double] {
        let calendar = Calendar.current
        let now = Date()
        var amounts: [Double] = []
        
        // Calculate balance change for last 4 weeks
        for weekOffset in 0..<4 {
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -(weekOffset + 1), to: now) ?? now
            let weekEnd = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now) ?? now
            
            let weekTransactions = dataManager.transactions.filter { transaction in
                transaction.date >= weekStart && transaction.date < weekEnd
            }
            
            let weeklyBalance = weekTransactions.reduce(0.0) { total, transaction in
                return total + transaction.amount
            }
            
            amounts.append(weeklyBalance)
        }
        
        return amounts.reversed() // Show oldest week first
    }
    
    private var averageWeeklyChange: Double {
        guard !weeklyAmounts.isEmpty else { return 0.0 }
        return weeklyAmounts.reduce(0, +) / Double(weeklyAmounts.count)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(animate ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animate)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.nestFlowTextPrimary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.nestFlowTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.nestFlowCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .opacity(animate ? 1.0 : 0.0)
        .offset(y: animate ? 0 : 20)
        .animation(.easeInOut(duration: 0.6).delay(0.4), value: animate)
    }
}

struct ExpenseCategoryRow: View {
    let category: Transaction.TransactionCategory
    let amount: Double
    let percentage: Double
    let animate: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: category.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.nestFlowSecondary)
                .frame(width: 24)
            
            // Category name
            Text(category.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.nestFlowTextPrimary)
            
            Spacer()
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.nestFlowCard.opacity(0.3))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.nestFlowSecondary)
                        .frame(
                            width: animate ? geometry.size.width * CGFloat(percentage) : 0,
                            height: 6
                        )
                        .animation(.easeInOut(duration: 1.0), value: animate)
                }
            }
            .frame(width: 60, height: 6)
            
            // Amount
            Text("$\(Int(amount))")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.nestFlowTextPrimary)
                .frame(width: 50, alignment: .trailing)
        }
    }
}

#Preview {
    StatisticsView(dataManager: AppDataManager())
}
