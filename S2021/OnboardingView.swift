//
//  OnboardingView.swift
//  S2021
//
//  Created by IGOR on 16/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var animateElements = false
    @Binding var hasCompletedOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Turn small actions into big results",
            description: "Every penny saved is a step closer to your dreams. Start your financial journey with purpose and clarity.",
            iconName: "leaf.fill",
            color: Color.nestFlowAccent
        ),
        OnboardingPage(
            title: "Visualize your growth and savings clearly",
            description: "Track your progress with beautiful charts and insights that make financial planning enjoyable and motivating.",
            iconName: "chart.line.uptrend.xyaxis",
            color: Color.nestFlowSecondary
        ),
        OnboardingPage(
            title: "Start building your financial nest today",
            description: "Join thousands who have transformed their financial habits. Your future self will thank you.",
            iconName: "house.fill",
            color: Color.nestFlowAccent
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color.nestFlowPrimary
                .ignoresSafeArea()
            
            // Floating background elements
            FloatingParticles()
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            animateElements: animateElements
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Bottom section
                VStack(spacing: 30) {
                    // Page indicators
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.nestFlowAccent : Color.nestFlowTextSecondary.opacity(0.3))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        if currentPage < pages.count - 1 {
                            // Next button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentPage += 1
                                }
                            }) {
                                HStack {
                                    Text("Continue")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.nestFlowAccent)
                                .cornerRadius(16)
                            }
                            
                            // Skip button
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    hasCompletedOnboarding = true
                                }
                            }) {
                                Text("Skip")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.nestFlowTextSecondary)
                            }
                        } else {
                            // Start button
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    hasCompletedOnboarding = true
                                }
                            }) {
                                HStack {
                                    Text("Start")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.nestFlowAccent, Color.nestFlowSecondary]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.nestFlowAccent.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .scaleEffect(animateElements ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animateElements)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
        .onChange(of: currentPage) { _ in
            // Reset and restart animations when page changes
            animateElements = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateElements = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let animateElements: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 1.0).delay(0.2), value: animateElements)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateElements ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateElements)
            }
            
            // Text content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.nestFlowTextPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateElements)
                
                Text(page.description)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.nestFlowTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeInOut(duration: 0.8).delay(0.8), value: animateElements)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FloatingParticles: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.nestFlowAccent.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...40))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    )
                    .offset(
                        x: animate ? CGFloat.random(in: -30...30) : 0,
                        y: animate ? CGFloat.random(in: -50...50) : 0
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}

