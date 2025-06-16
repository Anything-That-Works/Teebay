//
//  AllProducts.swift
//  Teebay
//
//  Created by Promal on 16/6/25.
//

import SwiftUI

struct AllProductsView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper
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
                    Text("All Products")
                        .font(.largeTitle.bold())
                }
                .padding(.horizontal)
                .padding(.bottom)
                ZStack(alignment: .bottomTrailing) {
                    List {
                        ForEach(viewModel.products, id: \.id) { item in
                            ProductView(item, showDeleteOption: false)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .disabled(viewModel.isProcessingRequest || viewModel.isShowingMenu)
                }
            }
            SideMenuView(currentView: .allProducts)
        }
        .onAppear(perform: viewModel.getProducts)
    }
}

#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser

    return NavigationStack {
        AllProductsView()
            .environmentObject(viewModel)
    }
}
