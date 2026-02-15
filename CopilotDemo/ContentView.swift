//
//  ContentView.swift
//  CopilotDemo
//
//  Created by Anurag Vishnoi on 14/02/26.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()

    var body: some View {
        if loginVM.isLoggedIn, let user = loginVM.currentUser {
            DashboardView(user: user, loginVM: loginVM)
        } else {
            NavigationView {
                LoginView(viewModel: loginVM)
            }
            .navigationViewStyle(.stack)
        }
    }
}

#Preview {
    ContentView()
}
