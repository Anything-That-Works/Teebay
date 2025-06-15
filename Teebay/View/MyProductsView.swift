//
//  ProductsView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct MyProductsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.products, id: \.id) { item in
                    ProductView(item)
                }
            }
            NavigationLink(destination: EmptyView()) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)

            }
        }
        .padding(.horizontal)
        .navigationTitle("My Products")
        .onAppear(perform: viewModel.getUsersProduct)
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
