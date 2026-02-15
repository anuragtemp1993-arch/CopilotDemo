//
//  AuthService.swift
//  CopilotDemo
//
//  Created by Copilot on 15/02/26.
//

import Foundation

public struct User: Codable {
    public let id: Int?
    public let name: String?
    public let email: String
    public let token: String?
}

public protocol AuthServiceProtocol {
    func fetchUser(email: String, password: String) async throws -> User
}

public final class AuthService: AuthServiceProtocol {
    public init() {}

    public enum AuthError: Error {
        case invalidResponse
        case serverError(String)
    }

    public func fetchUser(email: String, password: String) async throws -> User {
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

public final class MockAuthService: AuthServiceProtocol {
    public init() {}

    public func fetchUser(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 300 * 1_000_000)
        if email == "test@example.com" && password == "password123" {
            return User(id: 1, name: "Test User", email: email, token: "mock-token")
        }
        throw URLError(.userAuthenticationRequired)
    }
}
