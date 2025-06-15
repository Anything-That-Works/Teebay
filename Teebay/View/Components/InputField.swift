//
//  InputField.swift
//  Teebay
//
//  Created by Promal on 15/6/25.
//


import SwiftUI

struct InputField: View {
    @Binding var input: String
    @Binding var issue: String
    var hint: String
    var isSecure: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            if (isSecure) {
                SecureField(hint, text: $input)
                    .roundedBorder()
                    .autocorrectionDisabled(true)
            } else {
                TextField(hint, text: $input)
                    .roundedBorder()
                    .autocorrectionDisabled(true)
            }
            if (!issue.isEmpty) {
                Text(issue)
                    .font(.footnote)
                    .foregroundStyle(Color.red)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    InputField(
        input: Binding.constant(""),
        issue: Binding.constant("Input field can't be empty!"),
        hint: "First Name"
    )
    .padding()
}
