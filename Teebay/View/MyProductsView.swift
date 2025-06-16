//
//  ProductsView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct MyProductsView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isShowingMenu.toggle()
                            print("Show Menu")
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                    }
                    Text("My Products")
                        .font(.largeTitle.bold())
                }
                .padding(.horizontal)
                .padding(.bottom)
                ZStack(alignment: .bottomTrailing) {
                    List {
                        ForEach(viewModel.products.filter { $0.seller == viewModel.user?.id }, id: \.id) { item in
                            Button {
                                navigationHelper.push(AppRoute.editProductView(product: item))
                            } label: {
                                ProductView(item)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .disabled(viewModel.isProcessingRequest || viewModel.isShowingMenu)
                    Button {
                        navigationHelper.push(AppRoute.addProductView)
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .padding(.horizontal)
                    }
                    .disabled(viewModel.isProcessingRequest || viewModel.isShowingMenu)
                }
            }
            SideMenuView(currentView: .myProducts)
        }
        .onAppear(perform: viewModel.getProducts)
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
        .overlay {
            if viewModel.isProcessingRequest {
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
            .injectEnvironmentObjects(viewModel: viewModel)
    }
}
