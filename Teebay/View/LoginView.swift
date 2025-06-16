//
//  LoginView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct LoginView: View {
    @State private var input = LoginInput()
    @State private var error: AppError?
    @State private var showAlert = false
    @State private var isLoading = false

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

            VStack {
                Button("LOGIN", action: loginButtonAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading)

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
        }
        .alert("Error", isPresented: $showAlert) {
            Button("Retry", action: reset)
        } message: {
            Text(error?.errorDescription ?? "Something went wrong!!")
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
