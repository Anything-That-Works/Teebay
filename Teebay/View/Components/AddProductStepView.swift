//
//  AddProductStepView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct AddProductStepView: View {
    let index: Int
    @Binding var currentStep: Int
    @Binding var newProduct: Product

    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var inputImage: UIImage?

    private let maxOffset: CGFloat = 300

    var body: some View {
        cardContent
            .padding()
            .opacity(currentStep == index ? 1 : 0)
            .offset(x: CGFloat(index - currentStep) * maxOffset)
            .animation(.easeInOut, value: currentStep)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $inputImage, sourceType: .camera)
            }
            .onChange(of: inputImage) {
                loadImage()
            }
    }

    @ViewBuilder
    private var cardContent: some View {
        switch index {
        case 0: titleStep
        case 1: categoriesStep
        case 2: descriptionStep
        case 3: imageStep
        case 4: pricingStep
        case 5: summaryStep
        default: errorStep
        }
    }

    private var titleStep: some View {
        VStack {
            Text("Select a title for your product")
                .font(.headline)
                .multilineTextAlignment(.center)
            TextField("", text: $newProduct.title)
                .roundedBorder()
                .autocorrectionDisabled(true)
        }
    }

    private var categoriesStep: some View {
        VStack {
            Text("Select categories")
            HStack {
                Menu {
                    ForEach(Category.allCases, id: \.self) { category in
                        Button {
                            if let index = newProduct.categories.firstIndex(
                                of: category
                            ) {
                                newProduct.categories.remove(at: index)
                            } else {
                                newProduct.categories.append(category)
                            }
                        } label: {
                            HStack {
                                Text(category.value)
                                Spacer()
                                if newProduct.categories.contains(category) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text(
                        newProduct.categories.isEmpty
                            ? "Select a Category"
                            : newProduct.categories.map { $0.value }.joined(
                                separator: ", "
                            )
                    )
                }
            }
        }
    }

    private var descriptionStep: some View {
        VStack {
            Text("Add a description for your product")
                .font(.headline)
                .multilineTextAlignment(.center)
            TextEditor(text: $newProduct.description)
                .frame(height: 250)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }

    private var imageStep: some View {
        VStack(spacing: 30) {
            // Show selected image if available
            if !newProduct.productImage.isEmpty {
                if let data = Data(base64Encoded: newProduct.productImage),
                    let uiImage = UIImage(data: data)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(8)
                }
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            VStack(spacing: 20) {
                Button("Take Picture using Camera") {
                    showingCamera = true
                }
                .buttonStyle(.borderedProminent)

                Button("Upload Picture from Device") {
                    showingImagePicker = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var pricingStep: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Select Price")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                TextField("", text: $newProduct.purchasePrice)
                    .keyboardType(.decimalPad)
                    .roundedBorder()
                    .keyboardType(.decimalPad)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Rent Price")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                TextField("", text: $newProduct.rentPrice)
                    .keyboardType(.decimalPad)
                    .roundedBorder()
                    .keyboardType(.decimalPad)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Rent Option")
                    .font(.headline)
                Picker("Rent Option", selection: $newProduct.rentOption) {
                    ForEach([RentOption.hour, RentOption.day], id: \.self) {
                        option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var summaryStep: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Summery")
                    .font(.largeTitle.bold())
                if let data = Data(base64Encoded: newProduct.productImage),
                    let uiImage = UIImage(data: data)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(8)
                }
                Text("Title: \(newProduct.title)")
                Divider()
                Text(
                    "Categories: \(newProduct.categories.map { $0.value }.joined(separator: ", "))"
                )
                Divider()
                Text("Description: \(newProduct.description)")
                Divider()
                Text("Price: $\(newProduct.purchasePrice)")
                Divider()
                Text("To rent: $\(newProduct.rentPrice)")
                Divider()
                Text("per \(newProduct.rentOption)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var errorStep: some View {
        Text("Something went wrong: Index \(index)")
    }

    // Helper function to load the selected image
    private func loadImage() {
        guard let inputImage = inputImage else { return }

        // Convert UIImage to Data and store in product
        if let imageData = inputImage.jpegData(compressionQuality: 0.8) {
            newProduct.productImage = imageData.base64EncodedString()
        }
    }
}
