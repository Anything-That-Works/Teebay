//
//  ProductView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    let showDeleteOption: Bool
    @State private var isDescriptionExpanded = false
    @State private var isTruncated = false
    @State private var autoCollapseTask: Task<Void, Never>?
    @State private var showDeleteAlert = false
    @EnvironmentObject private var viewModel: ViewModel
    init(_ product: Product, showDeleteOption: Bool = true) {
        self.product = product
        self.showDeleteOption = showDeleteOption
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RemoteImageView(url: URL(string: product.productImage))
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.title)
                            .font(.title2.bold())
                        Spacer()
                        if showDeleteOption {
                            Button {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title3.bold())
                                    .foregroundStyle(Color.red)
                            }
                        }

                    }
                    if !product.categories.isEmpty {
                        HStack(spacing: 0) {
                            Text("Categories: ")
                            Text(product.categories.map { $0.rawValue }.joined(separator: ", "))
                        }.font(.footnote)
                    }
                }
            }
            HStack {
                Text("Price: $\(product.purchasePrice)")
                Text("Rent: $\(product.rentPrice)")
                Text(product.rentOption.label)
            }
            // Expandable description section
            VStack(alignment: .leading, spacing: 8) {
                Text(product.description)
                    .lineLimit(isDescriptionExpanded ? nil : 3)
                    .background(
                        Text(product.description)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(0)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            let height = geo.size.height
                                            isTruncated = height > 60
                                        }
                                }
                            )
                    )

                if isTruncated {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isDescriptionExpanded.toggle()
                        }

                        // Cancel existing auto-collapse task
                        autoCollapseTask?.cancel()

                        // Start auto-collapse timer when expanding
                        if isDescriptionExpanded {
                            autoCollapseTask = Task {
                                try? await Task.sleep(
                                    nanoseconds: 10_000_000_000
                                )  // 10 seconds

                                if !Task.isCancelled {
                                    await MainActor.run {
                                        withAnimation(.easeInOut(duration: 0.3))
                                        {
                                            isDescriptionExpanded = false
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text(
                            isDescriptionExpanded
                                ? "Less Details" : "More Details"
                        )
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }

            Text(
                "Date Posted: \(product.datePosted.formatted(.dateTime.day().month(.wide).year()))"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .onDisappear {
            autoCollapseTask?.cancel()
        }
        .alert("Confirm Delete", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete(product: product)
            }
            Button("Cancel", role: .cancel) {
                showDeleteAlert = false
            }
        } message: {
            Text("Are you sure you want to delete this item?")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProductView(Product.sampleProduct)
        .injectEnvironmentObjects()
        .padding()
}
