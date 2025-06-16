//
//  AddProductView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct AddProductView: View {
    @State var newProduct = Product.empty()
    @State private var currentStep = 0
    @State private var errors = [ValidationError]()
    @State private var showErrors = false
    @State private var showSuccessAlert = false

    private let totalSteps = 5

    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper
    var body: some View {
        VStack {
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .animation(.easeInOut, value: currentStep)
                .padding()

            Spacer()
            ZStack {
                ForEach(0...totalSteps, id: \.self) { index in
                    AddProductStepView(
                        index: index,
                        currentStep: $currentStep,
                        newProduct: $newProduct
                    )
                }
            }

            Spacer()

            HStack {
                Button("Back", action: goToPreviousStep)
                    .buttonStyle(.borderedProminent)
                    .disabled(currentStep == 0)
                    .opacity(currentStep == 0 ? 0 : 1)

                Spacer()

                Button(
                    currentStep == 5 ? "Submit" : "Next",
                    action: goToNextStep
                )
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .onAppear {
            guard let user = viewModel.user else {
                return print("User not Signed In")
            }
            newProduct.seller = user.id
        }
        .alert("Details Incomplete", isPresented: $showErrors) {
            Button("OK") {
                showErrors = false
            }
        } message: {
            Text(
                errors.map { "• \($0.localizedDescription)" }.joined(
                    separator: "\n"
                )
            )
            .font(.callout)
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("Done") {
                navigationHelper.pop()
            }
        } message: {
            Text("Product has been successfully added!")
        }
        .overlay {
            if viewModel.isProcessingRequest {
                ProgressView("Uploading...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
        }
    }

    func goToPreviousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    func goToNextStep() {
        if currentStep < 5 {
            currentStep += 1
        } else {
            let validationResult = validateProduct()
            if validationResult.isValid {
                viewModel.addNewProduct(newProduct)
                if (viewModel.processError == nil) {
                    showSuccessAlert = true
                }
            } else {
                errors = validationResult.errors
                showErrors = true
            }
        }
    }

}

#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser
    return AddProductView()
        .injectEnvironmentObjects(viewModel: viewModel)
}
