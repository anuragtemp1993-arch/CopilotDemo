//
//  LoginView.swift
//  CopilotDemo
//
//  Created by Copilot on 14/02/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm: LoginViewModel
    @State private var showPassword: Bool = false
    @State private var rememberMe: Bool = false

    public init(service: AuthServiceProtocol = MockAuthService()) {
        _vm = StateObject(wrappedValue: LoginViewModel(service: service))
    }

    var body: some View {
        ZStack {
            // Background gradient with decorative circles
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemPurple), Color(.systemBlue).opacity(0.9)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles to emulate screenshot blobs
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 260, height: 260)
                    .offset(x: 120, y: -280)
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 180, height: 180)
                    .offset(x: 160, y: -210)
            }
            .allowsHitTesting(false)
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 24)

                // Avatar circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.92))
                        .frame(width: 110, height: 110)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(.systemBlue))
                        .frame(width: 90, height: 90)
                }
                .padding(.bottom, 8)

                // Fields
                VStack(spacing: 14) {
                    // Email capsule field
                    HStack(spacing: 10) {
                        Image(systemName: "envelope.fill")
                            .foregroundStyle(.white.opacity(0.95))
                        TextField("Username", text: $vm.email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.white.opacity(0.25)))

                    // Password capsule field with eye toggle
                    HStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.white.opacity(0.95))
                        Group {
                            if showPassword {
                                TextField("Password", text: $vm.password)
                            } else {
                                SecureField("Password", text: $vm.password)
                            }
                        }
                        .foregroundStyle(.white)

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.white.opacity(0.25)))

                    // Remember me row
                    HStack(spacing: 10) {
                        Button(action: { rememberMe.toggle() }) {
                            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .buttonStyle(.plain)

                        Text("Remember me")
                            .foregroundStyle(.white.opacity(0.95))
                            .font(.system(size: 16, weight: .medium))

                        Spacer()
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 24)

                // Sign in button
                Button(action: {
                    vm.submit()
                    // TODO: persist rememberMe if desired
                }) {
                    Text("Sign in")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(vm.canSubmit ? Color(.systemCyan) : Color(.systemCyan).opacity(0.6))
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .disabled(!vm.canSubmit)

                // Forgot password link
                Button(action: {
                    vm.alertMessage = "Forgot password tapped"
                    vm.showAlert = true
                }) {
                    Text("Forgot password?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.9))
                        .underline()
                }
                .padding(.top, 6)

                Spacer()
            }
            .padding(.vertical, 24)
        }
        .alert("", isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.alertMessage)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(service: MockAuthService())
        }
    }
}
