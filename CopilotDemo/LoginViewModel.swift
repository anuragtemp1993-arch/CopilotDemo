//
//  LoginViewModel.swift
//  CopilotDemo
//
//  Created by Copilot on 14/02/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    private let service: AuthServiceProtocol

    public init(service: AuthServiceProtocol? = nil) {
        self.service = service ?? AuthService()
    }

    var isEmailValid: Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { return false }
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        return predicate.evaluate(with: email)
    }

    var isPasswordValid: Bool {
        // Example rule: at least 8 characters
        return password.count >= 8
    }

    var canSubmit: Bool {
        return isEmailValid && isPasswordValid
    }

    func submit() {
        if canSubmit {
            Task {
                await login()
            }
        } else {
            var reasons: [String] = []
            if !isEmailValid { reasons.append("enter a valid email") }
            if !isPasswordValid { reasons.append("password must be at least 8 characters") }
            alertMessage = "Please " + reasons.joined(separator: " and ") + "."
            showAlert = true
        }
    }

    private func login() async {
        do {
            let user = try await service.fetchUser(email: email, password: password)
            alertMessage = "Welcome, \(user.name ?? user.email)"
            showAlert = true
        } catch {
            alertMessage = "Login failed: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

