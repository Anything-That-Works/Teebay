//
//  EditProductView.swift
//  Teebay
//
//  Created by Promal on 16/6/25.
//

import SwiftUI

struct EditProductView: View {
    @State var product: Product
    @State private var productSnapShot: Product = Product.empty()
    
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper

    @State private var showSuccessAlert: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Title")
                        .font(.headline)
                    TextField("Add a title", text: $product.title)
                        .roundedBorder()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Categories")
                        .font(.headline)
                    HStack {
                        Menu {
                            ForEach(Category.allCases, id: \.self) { category in
                                Button {
                                    if let index = product.categories.firstIndex(
                                        of: category
                                    ) {
                                        product.categories.remove(at: index)
                                    } else {
                                        product.categories.append(category)
                                    }
                                } label: {
                                    HStack {
                                        Text(category.value)
                                        Spacer()
                                        if product.categories.contains(category) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text(
                                product.categories.isEmpty
                                ? "Select a Category"
                                : product.categories.map { $0.value }.joined(
                                    separator: ", "
                                )
                            )
                            .roundedBorder()
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                product.categories = []
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .foregroundStyle(Color.red)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    TextEditor(text: $product.description)
                        .frame(height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                pricingStep

                VStack {
                    Button {
                        viewModel.updateProduct(using: product)
                        if (viewModel.processError == nil) {
                            showSuccessAlert = true
                        }
                    } label: {
                        Text("Confirm Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!hasChanges())

                    Button {
                        navigationHelper.pop()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                .padding(.top, 20)

            }
            .padding(.horizontal)
            .navigationTitle("Edit")
            .onAppear {
                self.productSnapShot = product
            }
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {
                    viewModel.processError = nil
                }
            } message: {
                Text(
                    viewModel.processError?.errorDescription
                        ?? "Something went wrong!!"
                )
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("Done") {
                    navigationHelper.pop()
                }
            } message: {
                Text("Product has been successfully updated!")
            }
        }
    }

    private var pricingStep: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Select Price")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                TextField("", text: $product.purchasePrice)
                    .keyboardType(.decimalPad)
                    .roundedBorder()
                    .keyboardType(.decimalPad)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Rent Price")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                TextField("", text: $product.rentPrice)
                    .keyboardType(.decimalPad)
                    .roundedBorder()
                    .keyboardType(.decimalPad)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Rent Option")
                    .font(.headline)
                Picker("Rent Option", selection: $product.rentOption) {
                    ForEach([RentOption.hour, RentOption.day], id: \.self) {
                        option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .overlay {
            if viewModel.isProcessingRequest {
                ProgressView("Updating...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
        }
    }

    private func hasChanges() -> Bool {
        product.title != productSnapShot.title ||
        product.description != productSnapShot.description ||
        product.categories != productSnapShot.categories ||
        product.purchasePrice != productSnapShot.purchasePrice ||
        product.rentPrice != productSnapShot.rentPrice ||
        product.rentOption != productSnapShot.rentOption
    }

}

#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser
    return NavigationStack {
        EditProductView(product: Product.empty())
            .environmentObject(viewModel)
    }
}
