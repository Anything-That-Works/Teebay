//
//  RegistrationViewModel.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var formData = RegistrationFormData()
    @Published var fieldErrors = RegistrationFieldErrors()
    @Published var isRegistrationSuccessful: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var processError: AppError?
    private var cancellables = Set<AnyCancellable>()
    
    var hasEmptyFields: Bool {
        formData.firstName.isEmpty ||
        formData.lastName.isEmpty ||
        formData.address.isEmpty ||
        formData.email.isEmpty ||
        formData.password.isEmpty
    }
    
    var passwordsMatch: Bool {
        formData.password == confirmPassword
    }
    
    @Published var confirmPassword: String = "123123!aA"

    init() {
        print("RegistrationViewModel initialised")
        setupValidationPublishers()
    }

    deinit {
        print("RegistrationViewModel deallocated")
        cancellables.removeAll()
    }

    func registerButtonAction() {
        Task {
            do {
                let user = try await APIServices.register(using: formData)
                print(user)
                await MainActor.run {
                    isRegistrationSuccessful = true
                }
            } catch let appError as AppError {
                await MainActor.run {
                    processError = appError
                    showErrorAlert = true
                }
            } catch {
                await MainActor.run {
                    processError = AppError.serverError()
                    showErrorAlert = true
                }
            }
        }
    }


    func resetForm() {
        formData = RegistrationFormData()
        confirmPassword = ""
        fieldErrors = RegistrationFieldErrors()
        isRegistrationSuccessful = false
        processError = nil
    }


    private func setupValidationPublishers() {
        // First Name validation
        $formData
            .map(\.firstName)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] firstName in
                self?.validateFirstName(firstName) ?? ""
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.firstName = errorMessage
            }
            .store(in: &cancellables)

        // Last Name validation
        $formData
            .map(\.lastName)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] lastName in
                self?.validateLastName(lastName) ?? ""
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.lastName = errorMessage
            }
            .store(in: &cancellables)

        // Address validation
        $formData
            .map(\.address)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] address in
                self?.validateAddress(address) ?? ""
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.address = errorMessage
            }
            .store(in: &cancellables)

        // Email validation
        $formData
            .map(\.email)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] email in
                self?.validateEmail(email) ?? ""
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.email = errorMessage
            }
            .store(in: &cancellables)

        // Password validation
        $formData
            .map(\.password)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] password in
                self?.validatePassword(password) ?? ""
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.password = errorMessage
            }
            .store(in: &cancellables)

        // Confirm Password validation
        $confirmPassword
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] confirmPass in
                guard let self = self else { return "" }
                if confirmPass.isEmpty {
                    return ""
                }
                if confirmPass != self.formData.password {
                    return "Passwords do not match"
                }
                return self.validatePassword(confirmPass)
            }
            .sink { [weak self] errorMessage in
                self?.fieldErrors.confirmPassword = errorMessage
            }
            .store(in: &cancellables)
    }

    // MARK: - Validation Methods

    private func validateFirstName(_ firstName: String) -> String {
        guard !firstName.isEmpty else {
            return "" // Return empty for empty field (neutral state)
        }

        if firstName.count < 2 {
            return "First name must be at least 2 characters"
        }

        let nameRegex = "^[A-Za-z\\s'-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !namePredicate.evaluate(with: firstName) {
            return "First name contains invalid characters"
        }

        return "" // Valid
    }

    private func validateLastName(_ lastName: String) -> String {
        guard !lastName.isEmpty else {
            return ""
        }

        if lastName.count < 2 {
            return "Last name must be at least 2 characters"
        }

        let nameRegex = "^[A-Za-z\\s'-]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !namePredicate.evaluate(with: lastName) {
            return "Last name contains invalid characters"
        }

        return ""
    }

    private func validateAddress(_ address: String) -> String {
        guard !address.isEmpty else {
            return ""
        }

        if address.count < 5 {
            return "Address must be at least 5 characters"
        }

        if address.count > 200 {
            return "Address is too long (max 200 characters)"
        }

        return ""
    }

    private func validateEmail(_ email: String) -> String {
        guard !email.isEmpty else {
            return ""
        }

        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            if !email.contains("@") {
                return "Email must contain @"
            } else if !email.contains(".") || email.split(separator: "@").count != 2 {
                return "Invalid email format"
            } else if email.hasSuffix("@") || email.hasSuffix(".") {
                return "Incomplete email address"
            } else {
                return "Invalid email format"
            }
        }

        return ""
    }

    private func validatePassword(_ password: String) -> String {
        guard !password.isEmpty else {
            return ""
        }

        if password.count < 6 {
            return "Password must be at least 6 characters"
        }

        if password.count > 50 {
            return "Password is too long (max 50 characters)"
        }

        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil

        if !hasUppercase {
            return "Password must contain at least one uppercase letter"
        }

        if !hasLowercase {
            return "Password must contain at least one lowercase letter"
        }

        if !hasNumber {
            return "Password must contain at least one number"
        }

        if !hasSpecialChar {
            return "Password must contain at least one special character"
        }

        return ""
    }
}


