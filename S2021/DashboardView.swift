//
//  DashboardView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var dataManager: AppDataManager
    @State private var showingAddExpense = false
    @State private var showingAddSaving = false
    @State private var showingEditGoal = false
    @State private var animateProgress = false
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Progress Circle
                progressSection
                
                // Action buttons
                actionButtonsSection
                
                // Recent Activity
                recentActivitySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Color.nestFlowPrimary.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateProgress = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(dataManager: dataManager)
        }
        .sheet(isPresented: $showingAddSaving) {
            AddSavingView(dataManager: dataManager)
        }
        .sheet(isPresented: $showingEditGoal) {
            EditMonthlyGoalView(dataManager: dataManager)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Welcome back!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.nestFlowTextSecondary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6), value: animateCards)
            
            Text("Your Financial Journey")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.nestFlowTextPrimary)
                .opacity(animateCards ? 1.0 : 0.0)
                .offset(y: animateCards ? 0 : 20)
                .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateCards)
        }
        .padding(.top, 10)
    }
    
    private var progressSection: some View {
        VStack(spacing: 20) {
            // Progress Circle
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.nestFlowCard, lineWidth: 12)
                    .frame(width: 200, height: 200)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: animateProgress ? CGFloat(dataManager.monthlyProgress) : 0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.nestFlowAccent, Color.nestFlowSecondary]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animateProgress)
                
                // Center content
                VStack(spacing: 4) {
                    Text("\(Int(dataManager.monthlyProgress * 100))%")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.nestFlowTextPrimary)
                    
                    Text("Monthly Goal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.nestFlowTextSecondary)
                }
                .scaleEffect(animateProgress ? 1.0 : 0.8)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.5), value: animateProgress)
            }
            
            // Goal details
            VStack(spacing: 8) {
                HStack {
                    Text("Monthly Goal:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    Spacer()
                    
                    Text("$\(Int(dataManager.monthlyProgress * dataManager.monthlyGoal)) / $\(Int(dataManager.monthlyGoal))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.nestFlowTextPrimary)
                    
                    Button(action: {
                        showingEditGoal = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.nestFlowAccent)
                    }
                }
                
                Text("Keep going! You're doing great.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.nestFlowAccent)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .opacity(animateCards ? 1.0 : 0.0)
            .offset(y: animateCards ? 0 : 20)
            .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateCards)
        }
        .padding(.vertical, 20)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            // Add Expense Button
            Button(action: {
                showingAddExpense = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Add Expense")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.nestFlowSecondary)
                .cornerRadius(16)
                .shadow(color: Color.nestFlowSecondary.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(animateCards ? 1.0 : 0.9)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
            
            // Add Saving Button
            Button(action: {
                showingAddSaving = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Add Saving")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.nestFlowAccent)
                .cornerRadius(16)
                .shadow(color: Color.nestFlowAccent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(animateCards ? 1.0 : 0.9)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
        }
        .padding(.horizontal, 4)
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.nestFlowTextPrimary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.8), value: animateCards)
            
            if dataManager.transactions.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    VStack(spacing: 8) {
                        Text("No transactions yet")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Start by adding your first expense or saving!")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.nestFlowCard)
                .cornerRadius(16)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.9), value: animateCards)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(Array(dataManager.transactions.prefix(6).enumerated()), id: \.element.id) { index, transaction in
                        TransactionRowView(transaction: transaction)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .offset(x: animateCards ? 0 : -50)
                            .animation(.easeInOut(duration: 0.6).delay(0.9 + Double(index) * 0.1), value: animateCards)
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 48, height: 48)
                
                Image(systemName: transaction.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            // Transaction details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.nestFlowTextPrimary)
                
                Text(transaction.category.rawValue)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.nestFlowTextSecondary)
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(amountText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(amountColor)
                
                Text(dateText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.nestFlowTextSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.nestFlowCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var iconBackgroundColor: Color {
        switch transaction.type {
        case .income, .saving:
            return Color.nestFlowAccent.opacity(0.2)
        case .expense:
            return Color.nestFlowSecondary.opacity(0.2)
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .income, .saving:
            return Color.nestFlowAccent
        case .expense:
            return Color.nestFlowSecondary
        }
    }
    
    private var amountText: String {
        let prefix = transaction.amount >= 0 ? "+" : ""
        return "\(prefix)$\(String(format: "%.0f", abs(transaction.amount)))"
    }
    
    private var amountColor: Color {
        switch transaction.type {
        case .income, .saving:
            return Color.nestFlowAccent
        case .expense:
            return Color.nestFlowSecondary
        }
    }
    
    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: transaction.date)
    }
}

#Preview {
    DashboardView(dataManager: AppDataManager())
}

