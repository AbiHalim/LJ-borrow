//
//  DecimalTextField.swift
//  LJ Borrow
//
//  Created by Abi on 25/06/24.
//

import SwiftUI

import SwiftUI

struct DecimalTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.decimalPad)
            .onReceive(text.publisher.collect()) {
                let filtered = $0.map { String($0) }.joined()
                if let _ = Double(filtered), filtered.isValidDecimal() {
                    text = filtered
                } else {
                    text = String(filtered.dropLast())
                }
            }
    }
}

extension String {
    func isValidDecimal() -> Bool {
        let regex = "^[0-9]*\\.?[0-9]{0,2}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
