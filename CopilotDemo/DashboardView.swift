//
//  DashboardView.swift
//  CopilotDemo
//
//  Created by Copilot on 15/02/26.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var vm: DashboardViewModel
    @ObservedObject var loginVM: LoginViewModel
    
    init(user: User, loginVM: LoginViewModel) {
        _vm = StateObject(wrappedValue: DashboardViewModel(user: user))
        self.loginVM = loginVM
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome, \(vm.user.name ?? vm.user.email)")
                            .font(.largeTitle.weight(.semibold))
                        Text("Your Banking Dashboard")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                // Account Balance Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account Balance")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(vm.formattedBalance)
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.green)
                    Divider()
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Account Number")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(vm.accountNumber)
                                .font(.subheadline.weight(.semibold))
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Account Type")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(vm.accountType)
                                .font(.subheadline.weight(.semibold))
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Recent Transactions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Transactions")
                        .font(.headline)
                    
                    if vm.transactions.isEmpty {
                        VStack(alignment: .center, spacing: 8) {
                            Image(systemName: "list.bullet.clipboard")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            Text("No recent transactions")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(vm.transactions, id: \.id) { transaction in
                            HStack(spacing: 12) {
                                Image(systemName: transaction.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(transaction.color)
                                    .frame(width: 40, height: 40)
                                    .background(transaction.color.opacity(0.1))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(transaction.description)
                                        .font(.subheadline.weight(.semibold))
                                    Text(transaction.date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(transaction.formattedAmount)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(transaction.amount >= 0 ? .green : .red)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    loginVM.isLoggedIn = false
                    loginVM.currentUser = nil
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Transaction {
    let id: UUID = UUID()
    let description: String
    let amount: Double
    let date: String
    let icon: String
    let color: Color
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(
            user: User(id: 1, name: "John Doe", email: "john@example.com", token: "mock-token"),
            loginVM: LoginViewModel(service: MockAuthService())
        )
    }
}
