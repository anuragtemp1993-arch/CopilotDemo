//
//  DashboardViewModel.swift
//  CopilotDemo
//
//  Created by Copilot on 15/02/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoggedOut: Bool = false
    
    // Mock banking details
    let accountNumber: String = "****5678"
    let accountType: String = "Checking"
    let balance: Double = 5425.75
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    var transactions: [Transaction] {
        [
            Transaction(
                description: "Grocery Store",
                amount: -52.50,
                date: "Today",
                icon: "cart.fill",
                color: .blue
            ),
            Transaction(
                description: "Salary Deposit",
                amount: 3500.00,
                date: "Yesterday",
                icon: "arrow.down.circle.fill",
                color: .green
            ),
            Transaction(
                description: "Electric Bill",
                amount: -125.00,
                date: "Feb 13",
                icon: "bolt.fill",
                color: .orange
            ),
            Transaction(
                description: "ATM Withdrawal",
                amount: -200.00,
                date: "Feb 12",
                icon: "banknote.fill",
                color: .red
            ),
            Transaction(
                description: "Restaurant",
                amount: -35.99,
                date: "Feb 11",
                icon: "fork.knife",
                color: .pink
            )
        ]
    }
    
    init(user: User) {
        self.user = user
    }
    
    func logout() {
        isLoggedOut = true
    }
}
