//
//  ContentView.swift
//  CopilotDemo
//
//  Created by Anurag Vishnoi on 14/02/26.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
