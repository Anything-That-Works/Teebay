//
//  LoginView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @State private var input = LoginInput()
    @State private var error: AppError?
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var biometricType: BiometricAuthService.BiometricType = .none
    @State private var showBiometricPrompt = false
    @State private var showBiometricAlert = false

    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Sign In")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 20) {
                TextField("Email", text: $input.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .roundedBorder()
                SecureField("Password", text: $input.password)
                    .textContentType(.password)
                    .roundedBorder()
            }

            VStack(spacing: 15) {
                Button("LOGIN", action: loginButtonAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading)
                
                if biometricType != .none && BiometricAuthService.shared.isBiometricEnabled {
                    Button {
                        authenticateWithBiometrics()
                    } label: {
                        HStack {
                            Image(systemName: biometricType == .faceID ? "faceid" : "touchid")
                            Text(biometricType == .faceID ? "Sign in with Face ID" : "Sign in with Touch ID")
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isLoading)
                }

                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                    Button("Sign Up") {
                        navigationHelper.push(AppRoute.registrationView)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.reset()
            biometricType = BiometricAuthService.shared.biometricType
            
            // Check for stored credentials and biometric preference
            if BiometricAuthService.shared.isBiometricEnabled,
               let credentials = BiometricAuthService.shared.getStoredCredentials() {
                input.email = credentials.email
                input.password = credentials.password
                authenticateWithBiometrics()
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("Retry", action: reset)
        } message: {
            Text(error?.errorDescription ?? "Something went wrong!!")
        }
        .alert("Enable Face ID", isPresented: $showBiometricAlert) {
            Button("Enable") {
                BiometricAuthService.shared.storeCredentials(email: input.email, password: input.password)
                BiometricAuthService.shared.isBiometricEnabled = true
                showBiometricAlert = false
            }
            Button("Not Now", role: .cancel) {
                showBiometricAlert = false
            }
        } message: {
            Text("Would you like to enable Face ID for faster login next time?")
        }
    }

    private func loginButtonAction() {
        if input.email.isEmpty || input.password.isEmpty { return }
        isLoading = true
        Task {
            do {
                let user = try await APIServices.login(
                    email: input.email,
                    password: input.password
                )
                viewModel.user = user

                if biometricType != .none && !BiometricAuthService.shared.isBiometricEnabled {
                    showBiometricAlert = true
                }
                
                navigationHelper.push(AppRoute.myProductsView)
            } catch let appError as AppError {
                error = appError
                showAlert = true
            } catch {
                self.error = AppError.unknownError
                showAlert = true
            }
            isLoading = false
        }
    }
    
    private func authenticateWithBiometrics() {
        isLoading = true
        Task {
            do {
                try await BiometricAuthService.shared.authenticate()
                // If biometric authentication succeeds, proceed with login
                let user = try await APIServices.login(
                    email: input.email,
                    password: input.password
                )
                viewModel.user = user
                navigationHelper.push(AppRoute.myProductsView)
            } catch let appError as AppError {
                error = appError
                showAlert = true
            } catch {
                self.error = AppError.unknownError
                showAlert = true
            }
            isLoading = false
        }
    }

    private func reset() {
        input = LoginInput()
        error = nil
    }

    struct LoginInput {
        var email = "max@well.com"
        var password = "123123"
    }
}

#Preview {
    LoginView()
        .injectEnvironmentObjects()
}
