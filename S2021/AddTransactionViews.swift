//
//  AddTransactionViews.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

// MARK: - Add Expense View
struct AddExpenseView: View {
    @ObservedObject var dataManager: AppDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: Transaction.TransactionCategory = .groceries
    @State private var animateElements = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.nestFlowSecondary)
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                        
                        Text("Add Expense")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Track your spending")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                    }
                    .padding(.top, 20)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8), value: animateElements)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Amount input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            HStack {
                                Text("$")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.nestFlowAccent)
                                
                                TextField("0.00", text: $amount)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.nestFlowTextPrimary)
                                    .keyboardType(.decimalPad)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.nestFlowCard)
                            .cornerRadius(16)
                        }
                        
                        // Description input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            TextField("What did you spend on?", text: $description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.nestFlowTextPrimary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.nestFlowCard)
                                .cornerRadius(16)
                        }
                        
                        // Category selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(Transaction.TransactionCategory.allCases.filter { $0 != .savings }, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        action: { selectedCategory = category }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateElements)
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.nestFlowPrimary.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.nestFlowTextSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addExpense()
                    }
                    .foregroundColor(.nestFlowAccent)
                    .disabled(amount.isEmpty || description.isEmpty)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
    }
    
    private func addExpense() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }
        
        dataManager.addExpense(
            amount: amountValue,
            description: description,
            category: selectedCategory
        )
        
        dismiss()
    }
}

// MARK: - Add Saving View
struct AddSavingView: View {
    @ObservedObject var dataManager: AppDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var animateElements = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.nestFlowAccent)
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                        
                        Text("Add Saving")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Build your financial future")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                    }
                    .padding(.top, 20)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8), value: animateElements)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Amount input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            HStack {
                                Text("$")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.nestFlowAccent)
                                
                                TextField("0.00", text: $amount)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.nestFlowTextPrimary)
                                    .keyboardType(.decimalPad)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.nestFlowCard)
                            .cornerRadius(16)
                        }
                        
                        // Description input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            TextField("What are you saving for?", text: $description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.nestFlowTextPrimary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.nestFlowCard)
                                .cornerRadius(16)
                        }
                        
                        // Motivational message
                        VStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.nestFlowAccent)
                            
                            Text("Every dollar saved is a step closer to your dreams!")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.nestFlowAccent)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(Color.nestFlowAccent.opacity(0.1))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateElements)
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.nestFlowPrimary.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.nestFlowTextSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addSaving()
                    }
                    .foregroundColor(.nestFlowAccent)
                    .disabled(amount.isEmpty || description.isEmpty)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
    }
    
    private func addSaving() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }
        
        dataManager.addSaving(
            amount: amountValue,
            description: description
        )
        
        dismiss()
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let category: Transaction.TransactionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .black : .nestFlowTextPrimary)
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .black : .nestFlowTextPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.nestFlowAccent : Color.nestFlowCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.nestFlowAccent : Color.clear, lineWidth: 2)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview("Add Expense") {
    AddExpenseView(dataManager: AppDataManager())
}

#Preview("Add Saving") {
    AddSavingView(dataManager: AppDataManager())
}

