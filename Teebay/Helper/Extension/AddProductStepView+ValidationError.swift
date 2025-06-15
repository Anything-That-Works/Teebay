//
//  ValidationError.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

// MARK: - Product Validation
extension AddProductView {

    /// Validates all product input fields and returns validation results
    /// - Returns: A tuple containing validation status and detailed error messages
    func validateProduct() -> (isValid: Bool, errors: [ValidationError]) {
        var errors: [ValidationError] = []

        // Step 0: Title validation
        if newProduct.title.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        {
            errors.append(.emptyTitle)
        } else if newProduct.title.count < 3 {
            errors.append(.titleTooShort)
        } else if newProduct.title.count > 100 {
            errors.append(.titleTooLong)
        }

        // Step 1: Categories validation
        if newProduct.categories.isEmpty {
            errors.append(.noCategories)
        }

        // Step 2: Description validation
        if newProduct.description.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty {
            errors.append(.emptyDescription)
        } else if newProduct.description.count < 10 {
            errors.append(.descriptionTooShort)
        } else if newProduct.description.count > 1000 {
            errors.append(.descriptionTooLong)
        }

        // Step 3: Image validation
        if newProduct.productImage.isEmpty {
            errors.append(.noImage)
        }

        // Step 4: Pricing validation
        let purchasePrice = Double(newProduct.purchasePrice)
        let rentPrice = Double(newProduct.rentPrice)

        if purchasePrice == nil || purchasePrice! <= 0 {
            errors.append(.invalidPurchasePrice)
        }

        if rentPrice == nil || rentPrice! <= 0 {
            errors.append(.invalidRentPrice)
        }

        // Additional business logic validations
        if let purchase = purchasePrice, let rent = rentPrice, rent >= purchase
        {
            errors.append(.rentPriceHigherThanPurchase)
        }

        return (isValid: errors.isEmpty, errors: errors)
    }

    /// Validates a specific step
    /// - Parameter step: The step index to validate
    /// - Returns: Validation result for the specific step
    func validateStep(_ step: Int) -> (isValid: Bool, errors: [ValidationError])
    {
        var errors: [ValidationError] = []

        switch step {
        case 0:  // Title step
            if newProduct.title.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            {
                errors.append(.emptyTitle)
            } else if newProduct.title.count < 3 {
                errors.append(.titleTooShort)
            } else if newProduct.title.count > 100 {
                errors.append(.titleTooLong)
            }

        case 1:  // Categories step
            if newProduct.categories.isEmpty {
                errors.append(.noCategories)
            }

        case 2:  // Description step
            if newProduct.description.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty {
                errors.append(.emptyDescription)
            } else if newProduct.description.count < 10 {
                errors.append(.descriptionTooShort)
            } else if newProduct.description.count > 1000 {
                errors.append(.descriptionTooLong)
            }

        case 3:  // Image step
            if newProduct.productImage.isEmpty {
                errors.append(.noImage)
            }

        case 4:  // Pricing step
            let purchasePrice = Double(newProduct.purchasePrice)
            let rentPrice = Double(newProduct.rentPrice)

            if purchasePrice == nil || purchasePrice! <= 0 {
                errors.append(.invalidPurchasePrice)
            }

            if rentPrice == nil || rentPrice! <= 0 {
                errors.append(.invalidRentPrice)
            }

            if let purchase = purchasePrice, let rent = rentPrice,
                rent >= purchase
            {
                errors.append(.rentPriceHigherThanPurchase)
            }

        default:
            break
        }

        return (isValid: errors.isEmpty, errors: errors)
    }

    /// Check if a specific step can be proceeded from (has valid input)
    /// - Parameter step: The step index to check
    /// - Returns: Boolean indicating if the step is valid enough to proceed
    func canProceedFromStep(_ step: Int) -> Bool {
        return validateStep(step).isValid
    }

    /// Get user-friendly error messages for display
    /// - Parameter errors: Array of validation errors
    /// - Returns: Formatted error message string
    func getErrorMessages(_ errors: [ValidationError]) -> String {
        return errors.map { $0.localizedDescription }.joined(separator: "\n")
    }
}

// MARK: - Validation Error Types
enum ValidationError: CaseIterable, Hashable {
    case emptyTitle
    case titleTooShort
    case titleTooLong
    case noCategories
    case emptyDescription
    case descriptionTooShort
    case descriptionTooLong
    case noImage
    case invalidPurchasePrice
    case invalidRentPrice
    case rentPriceHigherThanPurchase

    var localizedDescription: String {
        switch self {
        case .emptyTitle:
            return "Product title is required"
        case .titleTooShort:
            return "Product title must be at least 3 characters long"
        case .titleTooLong:
            return "Product title must be less than 100 characters"
        case .noCategories:
            return "At least one category must be selected"
        case .emptyDescription:
            return "Product description is required"
        case .descriptionTooShort:
            return "Product description must be at least 10 characters long"
        case .descriptionTooLong:
            return "Product description must be less than 1000 characters"
        case .noImage:
            return "Product image is required"
        case .invalidPurchasePrice:
            return "Purchase price must be greater than 0"
        case .invalidRentPrice:
            return "Rent price must be greater than 0"
        case .rentPriceHigherThanPurchase:
            return "Rent price should be lower than purchase price"
        }
    }

    var stepIndex: Int {
        switch self {
        case .emptyTitle, .titleTooShort, .titleTooLong:
            return 0
        case .noCategories:
            return 1
        case .emptyDescription, .descriptionTooShort, .descriptionTooLong:
            return 2
        case .noImage:
            return 3
        case .invalidPurchasePrice, .invalidRentPrice,
            .rentPriceHigherThanPurchase:
            return 4
        }
    }
}
