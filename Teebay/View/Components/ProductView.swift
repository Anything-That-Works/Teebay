//
//  ProductView.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    @State private var isDescriptionExpanded = false
    @State private var isTruncated = false
    @State private var autoCollapseTask: Task<Void, Never>?

    init(_ product: Product) {
        self.product = product
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title)
                .font(.title2.bold())
            if !product.categories.isEmpty {
                Text("Categories: ") +
                Text(product.categories.map { $0.rawValue }.joined(separator: ", "))
            }

            HStack {
                Text("Price:")
                Text(product.purchasePrice, format: .currency(code: "USD"))
                Divider()
                Text("Rent:")
                Text(product.rentPrice, format: .currency(code: "USD"))
                Text(product.rentOption.label)
            }.fixedSize()

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
                                try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds

                                if !Task.isCancelled {
                                    await MainActor.run {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isDescriptionExpanded = false
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text(isDescriptionExpanded ? "Less Details" : "More Details")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            Text("Date Posted: \(product.datePosted.formatted(.dateTime.day().month(.wide).year()))")
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
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProductView(Product.sampleProduct)
        .padding()
}
