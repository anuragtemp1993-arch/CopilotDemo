//
//  AuthService.swift
//  CopilotDemo
//
//  Created by Copilot on 14/02/26.
//

import Foundation

// Simple user model used by the service
public struct User: Codable {
    public let id: Int?
    public let name: String?
    public let email: String
    public let token: String?
}

// Protocol defines the API surface for authentication-related network calls.
public protocol AuthServiceProtocol {
    func fetchUser(email: String, password: String) async throws -> User
}

// Concrete implementation using URLSession. Replace endpoint with your backend.
public final class AuthService: AuthServiceProtocol {
    public init() {}

    public enum AuthError: Error {
        case invalidResponse
        case serverError(String)
    }

    public func fetchUser(email: String, password: String) async throws -> User {
        // Example endpoint — replace with real API.
        guard let url = URL(string: "https://example.com/api/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw AuthError.invalidResponse }

        if (200...299).contains(http.statusCode) {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } else {
            let message = String(data: data, encoding: .utf8) ?? "Server error"
            throw AuthError.serverError(message)
        }
    }
}

// A lightweight mock service for local testing and previews.
public final class MockAuthService: AuthServiceProtocol {
    public init() {}

    public func fetchUser(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 300 * 1_000_000)
        if email == "anuragtemp1993@gmail.com" && password == "password123" {
            return User(id: 1, name: "Test User", email: email, token: "mock-token")
        }
        throw URLError(.userAuthenticationRequired)
    }
}
