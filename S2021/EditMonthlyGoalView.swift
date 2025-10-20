//
//  EditMonthlyGoalView.swift
//  S2021
//
//  Created by IGOR on 19/10/2025.
//

import SwiftUI

struct EditMonthlyGoalView: View {
    @ObservedObject var dataManager: AppDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var newGoalAmount: String = ""
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            // Background
            Color.nestFlowPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Navigation Bar
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.nestFlowTextSecondary)
                    
                    Spacer()
                    
                    Text("Edit Monthly Goal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Save") {
                        saveGoal()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(newGoalAmount.isEmpty ? .gray : .nestFlowAccent)
                    .disabled(newGoalAmount.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Content
                VStack(spacing: 24) {
                    // Header Icon
                    Image(systemName: "target")
                        .font(.system(size: 60))
                        .foregroundColor(.nestFlowAccent)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                    
                    // Current Goal Info
                    VStack(spacing: 8) {
                        Text("Current Monthly Goal")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("$\(Int(dataManager.monthlyGoal))")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.nestFlowAccent)
                    }
                    
                    // Progress Info
                    VStack(spacing: 12) {
                        Text("This month: $\(Int(dataManager.monthlyProgress * dataManager.monthlyGoal))")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("\(Int(dataManager.monthlyProgress * 100))% Complete")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.nestFlowAccent)
                    }
                    .padding(20)
                    .background(Color.nestFlowCard)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // New Goal Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("New Monthly Goal")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.nestFlowAccent)
                            
                            TextField("\(Int(dataManager.monthlyGoal))", text: $newGoalAmount)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                        }
                        .padding(20)
                        .background(Color.nestFlowCard)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateElements)
                    
                    // Suggestions
                    VStack(spacing: 12) {
                        Text("Suggested Goals")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ForEach([500, 750, 1000, 1250, 1500, 2000], id: \.self) { amount in
                                Button(action: {
                                    newGoalAmount = String(amount)
                                }) {
                                    Text("$\(amount)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(newGoalAmount == String(amount) ? .black : .white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(newGoalAmount == String(amount) ? Color.nestFlowAccent : Color.nestFlowCard)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateElements)
                }
                
                Spacer()
            }
        }
        .onAppear {
            newGoalAmount = String(Int(dataManager.monthlyGoal))
            animateElements = true
        }
    }
    
    private func saveGoal() {
        guard let amount = Double(newGoalAmount), amount > 0 else { return }
        
        dataManager.monthlyGoal = amount
        dismiss()
    }
}

#Preview {
    EditMonthlyGoalView(dataManager: AppDataManager())
}
