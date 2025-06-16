//
//  SideMenuView.swift
//  Teebay
//
//  Created by Promal on 16/6/25.
//

import SwiftUI

enum SideMenuOption {
    case myProducts
    case allProducts
}

struct SideMenuView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var navigationHelper: NavigationHelper
    var currentView: SideMenuOption

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 25) {
                Button {
                    withAnimation {
                        viewModel.isShowingMenu = false
                    }
                    navigationHelper.push(AppRoute.myProductsView)
                } label:  {
                    Text("My Products")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentView == .myProducts)

                Button {
                    withAnimation {
                        viewModel.isShowingMenu = false
                    }
                    navigationHelper.push(AppRoute.allProductView)
                } label:  {
                    Text("All Products")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(currentView == .allProducts)

                Spacer()
                Button {
                    withAnimation {
                        viewModel.isShowingMenu = false
                    }
                    navigationHelper.popToRoot()
                } label: {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

            }
            .padding()
            .padding(.top, getBounds().height/5)
            .frame(width: Constants.mainviewOffset, alignment: .leading)
            .background(Color.gray.ignoresSafeArea().onTapGesture(perform: {
                withAnimation {
                    viewModel.isShowingMenu = false
                }
            }))
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(x: viewModel.isShowingMenu ? 0 : -(Constants.mainviewOffset + 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}


#Preview {
    let viewModel = ViewModel()
    viewModel.user = User.sampleUser
    viewModel.isShowingMenu = true
    return NavigationStack {
        SideMenuView(currentView: .myProducts)
    }
    .environmentObject(viewModel)
}
