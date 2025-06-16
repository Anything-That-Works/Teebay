//
//  ProductsView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct MyProductsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showDeleteAlert = false
    @State private var indexSetToDelete: IndexSet?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(viewModel.products, id: \.id) { item in
                    NavigationLink {
                        EditProductView(product: item)
                    } label: {
                        ProductView(item)
                    }

                }
                .onDelete { indexSet in
                    indexSetToDelete = indexSet
                    showDeleteAlert = true
                }
            }
            .listStyle(PlainListStyle())
            .disabled(viewModel.isDeleting)

            NavigationLink(destination: AddProductView()) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .padding(.horizontal)
            }
            .disabled(viewModel.isDeleting)
        }
        .navigationTitle("My Products")
        .onAppear(perform: viewModel.getProducts)
        .alert("Confirm Delete", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let indexSet = indexSetToDelete {
                    print(indexSet)
                    viewModel.deleteProduct(at: indexSet)
                }
            }
            Button("Cancel", role: .cancel) {
                indexSetToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {
                viewModel.processError = nil
            }
        } message: {
            Text(viewModel.processError?.errorDescription ?? "Something went wrong!!")
        }
        .overlay {
            if viewModel.isDeleting {
                ProgressView("Deleting...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser

    return NavigationStack {
        MyProductsView()
            .environmentObject(viewModel)
    }
}
