//
//  ContentView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = AppDataManager()
    
    var body: some View {
        Group {
            if dataManager.hasCompletedOnboarding {
                MainTabView(dataManager: dataManager)
            } else {
                OnboardingView(hasCompletedOnboarding: $dataManager.hasCompletedOnboarding)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainTabView: View {
    @ObservedObject var dataManager: AppDataManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(dataManager: dataManager)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            GoalsView(dataManager: dataManager)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "target" : "target")
                    Text("Goals")
                }
                .tag(1)
            
            StatisticsView(dataManager: dataManager)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
        }
        .accentColor(.nestFlowAccent)
        .background(Color.nestFlowPrimary.ignoresSafeArea())
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.nestFlowCard)
            
            // Normal state
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.nestFlowTextSecondary)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(Color.nestFlowTextSecondary),
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            // Selected state
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.nestFlowAccent)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color.nestFlowAccent),
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
