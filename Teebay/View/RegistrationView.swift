//
//  RegistrationView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @EnvironmentObject private var navigationHelper: NavigationHelper

    var body: some View {
        VStack(spacing: 50) {
            Text("Sign Up")
                .font(.largeTitle.bold())
            VStack(spacing: 20) {
                InputField(
                    input: $viewModel.formData.firstName,
                    issue: $viewModel.fieldErrors.firstName,
                    hint: "First Name"
                )
                InputField(
                    input: $viewModel.formData.lastName,
                    issue: $viewModel.fieldErrors.lastName,
                    hint: "Last Name"
                )
                InputField(
                    input: $viewModel.formData.address,
                    issue: $viewModel.fieldErrors.address,
                    hint: "Address"
                )
                InputField(
                    input: $viewModel.formData.email,
                    issue: $viewModel.fieldErrors.email,
                    hint: "Email"
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                InputField(
                    input: $viewModel.formData.password,
                    issue: $viewModel.fieldErrors.password,
                    hint: "Password",
                    isSecure: true
                )
                .textInputAutocapitalization(.never)
                InputField(
                    input: $viewModel.confirmPassword,
                    issue: $viewModel.fieldErrors.confirmPassword,
                    hint: "Confirm Password",
                    isSecure: true
                )
                .textInputAutocapitalization(.never)
            }

            VStack {
                Button(action: viewModel.registerButtonAction) {
                    Text("REGISTER")
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.hasEmptyFields || !viewModel.passwordsMatch)

                HStack(spacing: 0) {
                    Text("Already have an account? ")

                    Button("Sign In") {
                        navigationHelper.pop()
                    }
                }
            }
        }
        .padding(.horizontal)
        .alert("Success!", isPresented: $viewModel.isRegistrationSuccessful) {
            Button("Done") {
                navigationHelper.pop()
            }
        } message: {
            Text("Registration completed successfully.")
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("Retry", action: {})
        } message: {
            Text(
                viewModel.processError?.errorDescription
                    ?? "Something went wrong!!"
            )
        }
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
            .injectEnvironmentObjects()
    }
}
