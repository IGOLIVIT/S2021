//
//  GoalsView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var dataManager: AppDataManager
    @State private var showingAddGoal = false
    @State private var showingAddFunds = false
    @State private var selectedGoal: SavingGoal?
    @State private var addFundsGoal: SavingGoal = SavingGoal(name: "", targetAmount: 0, currentAmount: 0, createdDate: Date())
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Goals list
                goalsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Color.nestFlowPrimary.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateCards = true
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(dataManager: dataManager)
        }
        .sheet(isPresented: $showingAddFunds) {
            AddFundsView(dataManager: dataManager, goal: addFundsGoal)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Your Goals")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.nestFlowTextPrimary)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.6), value: animateCards)
                
                Text("Turn dreams into achievable targets")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.nestFlowTextSecondary)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.6).delay(0.2), value: animateCards)
            }
            
            // Add Goal Button moved to header
            Button(action: {
                showingAddGoal = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("Add New Goal")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.nestFlowAccent)
                .cornerRadius(16)
                .shadow(color: Color.nestFlowAccent.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(animateCards ? 1.0 : 0.9)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
        }
        .padding(.top, 10)
    }
    
    private var goalsSection: some View {
        Group {
            if dataManager.savingGoals.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "target")
                        .font(.system(size: 40))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    VStack(spacing: 8) {
                        Text("No goals yet")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.nestFlowTextPrimary)
                        
                        Text("Create your first savings goal to get started!")
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
                .animation(.easeInOut(duration: 0.6).delay(0.6), value: animateCards)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(Array(dataManager.savingGoals.enumerated()), id: \.element.id) { index, goal in
                        GoalCardView(
                            goal: goal,
                            onAddFunds: {
                                addFundsGoal = goal
                                showingAddFunds = true
                            },
                            onDeleteGoal: {
                                dataManager.deleteGoal(goalId: goal.id)
                            }
                        )
                        .opacity(animateCards ? 1.0 : 0.0)
                        .offset(y: animateCards ? 0 : 50)
                        .animation(.easeInOut(duration: 0.6).delay(0.3 + Double(index) * 0.1), value: animateCards)
                    }
                }
            }
        }
    }
    
}

struct GoalCardView: View {
    let goal: SavingGoal
    let onAddFunds: () -> Void
    let onDeleteGoal: () -> Void
    @State private var animateProgress = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.nestFlowTextPrimary)
                    
                    if let targetDate = goal.targetDate {
                        Text("Target: \(targetDate, formatter: dateFormatter)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.nestFlowTextSecondary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Delete button
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.nestFlowSecondary)
                    }
                    
                    if goal.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.nestFlowAccent)
                    }
                }
            }
            
            // Progress section
            VStack(spacing: 12) {
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.nestFlowCard)
                            .frame(height: 12)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.nestFlowAccent, Color.nestFlowSecondary]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: animateProgress ? geometry.size.width * CGFloat(goal.progress) : 0,
                                height: 12
                            )
                            .animation(.easeInOut(duration: 1.0), value: animateProgress)
                    }
                }
                .frame(height: 12)
                
                // Progress details
                HStack {
                    Text("$\(Int(goal.currentAmount))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.nestFlowAccent)
                    
                    Spacer()
                    
                    Text("$\(Int(goal.targetAmount))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.nestFlowTextPrimary)
                }
                
                // Progress percentage
                HStack {
                    Text("\(Int(goal.progress * 100))% Complete")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.nestFlowTextSecondary)
                    
                    Spacer()
                    
                    Text("$\(Int(goal.targetAmount - goal.currentAmount)) to go")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.nestFlowTextSecondary)
                }
            }
            
            // Add funds button
            if !goal.isCompleted {
                Button(action: onAddFunds) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("Add Funds")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.nestFlowAccent)
                    .cornerRadius(12)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.nestFlowAccent)
                    
                    Text("Goal Achieved!")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.nestFlowAccent)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.nestFlowAccent.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(24)
        .background(Color.nestFlowCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateProgress = true
            }
        }
        .alert("Delete Goal", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDeleteGoal()
            }
        } message: {
            Text("Are you sure you want to delete '\(goal.name)'? This action cannot be undone.")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}


// MARK: - Add Funds View
struct AddFundsView: View {
    @ObservedObject var dataManager: AppDataManager
    let goal: SavingGoal
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
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
                    
                    Text("Add Funds")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Add") {
                        addFunds()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(amount.isEmpty ? .gray : .nestFlowAccent)
                    .disabled(amount.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Content
                VStack(spacing: 24) {
                    // Header Icon
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.nestFlowAccent)
                    
                    // Goal Info
                    VStack(spacing: 8) {
                        Text("Adding funds to")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(goal.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.nestFlowAccent)
                    }
                    
                    // Progress Info
                    VStack(spacing: 12) {
                        Text("Current: $\(Int(goal.currentAmount)) / $\(Int(goal.targetAmount))")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("\(Int(goal.progress * 100))% Complete")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.nestFlowAccent)
                    }
                    .padding(20)
                    .background(Color.nestFlowCard)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    // Amount Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amount to Add")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.nestFlowAccent)
                            
                            TextField("0.00", text: $amount)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                        }
                        .padding(20)
                        .background(Color.nestFlowCard)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .onAppear {
            animateElements = true
        }
    }
    
    private func addFunds() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }
        
        dataManager.addFundsToGoal(goalId: goal.id, amount: amountValue)
        dismiss()
    }
}

// MARK: - Add Goal View
struct AddGoalView: View {
    @ObservedObject var dataManager: AppDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var targetAmount: String = ""
    @State private var hasTargetDate = false
    @State private var targetDate = Date().addingTimeInterval(86400 * 30) // 30 days from now
    @State private var animateElements = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.nestFlowPrimary
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "target")
                                .font(.system(size: 50))
                                .foregroundColor(.nestFlowAccent)
                                .scaleEffect(animateElements ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                            
                            Text("New Goal")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.nestFlowTextPrimary)
                            
                            Text("Set a target and start saving")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.nestFlowTextSecondary)
                        }
                        .padding(.top, 20)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8), value: animateElements)
                        
                        // Form
                        VStack(spacing: 20) {
                            // Goal name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Goal Name")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.nestFlowTextPrimary)
                                
                                TextField("e.g., New iPhone, Vacation", text: $name)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.nestFlowTextPrimary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(Color.nestFlowCard)
                                    .cornerRadius(16)
                            }
                            
                            // Target amount
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Target Amount")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.nestFlowTextPrimary)
                                
                                HStack {
                                    Text("$")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.nestFlowAccent)
                                    
                                    TextField("0.00", text: $targetAmount)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.nestFlowTextPrimary)
                                        .keyboardType(.decimalPad)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.nestFlowCard)
                                .cornerRadius(16)
                            }
                            
                            // Target date toggle
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle("Set Target Date", isOn: $hasTargetDate)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.nestFlowTextPrimary)
                                    .tint(.nestFlowAccent)
                                
                                if hasTargetDate {
                                    DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.nestFlowTextPrimary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(Color.nestFlowCard)
                                        .cornerRadius(16)
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
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.nestFlowTextSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createGoal()
                    }
                    .foregroundColor(.nestFlowAccent)
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
        .onAppear {
            // Customize navigation bar appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.nestFlowPrimary)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            animateElements = true
        }
    }
    
    private func createGoal() {
        guard let amount = Double(targetAmount), amount > 0 else { return }
        
        let goal = SavingGoal(
            name: name,
            targetAmount: amount,
            currentAmount: 0,
            createdDate: Date(),
            targetDate: hasTargetDate ? targetDate : nil
        )
        
        dataManager.addGoal(goal)
        dismiss()
    }
}

#Preview("Goals") {
    GoalsView(dataManager: AppDataManager())
}

#Preview("Add Goal") {
    AddGoalView(dataManager: AppDataManager())
}
