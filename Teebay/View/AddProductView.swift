//
//  AddProductView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct AddProductView: View {
    @State var newProduct = Product.empty()
    @State private var currentStep = 5
    @EnvironmentObject var viewModel: ViewModel
    @State private var errors = [ValidationError]()
    @State private var showErrors = false
    private let totalSteps = 5
    var body: some View {
        VStack {
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .animation(.easeInOut, value: currentStep)
                .padding()

            Spacer()

            ZStack {
                ForEach(0...totalSteps, id: \.self) { index in
                    AddProductStepView(index: index, currentStep: $currentStep, newProduct: $newProduct)
                }
            }

            Spacer()

            HStack {
                Button("Back", action: goToPreviousStep)
                    .buttonStyle(.borderedProminent)
                    .disabled(currentStep == 0)
                    .opacity(currentStep == 0 ? 0 : 1)

                Spacer()

                Button(currentStep == 5 ? "Submit" : "Next", action: goToNextStep)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        // TODO: - Finish this later
        .alert("Details Incomplete", isPresented: $showErrors) {
            ForEach(errors, id: \.self) { error in
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
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
            if (validationResult.isValid) {
                submitProduct()
            } else {
                errors = validationResult.errors
                showErrors = true
            }
        }
    }

    private func submitProduct() {
        print("Submitting product...")
    }


}

#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser
    return AddProductView()
        .environmentObject(viewModel)
}

