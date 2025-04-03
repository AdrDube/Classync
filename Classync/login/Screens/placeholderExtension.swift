//
//  placeholderExtension.swift
//  login
//
//  Created by Njabulo Moyo on 4/2/25.
//
import SwiftUI

extension View {
    func placeholderStyle(_ placeholder: String, color: Color, show: Bool) -> some View {
        ZStack(alignment: .leading) {
            if show {
                Text(placeholder)
                    .foregroundColor(color)
                    .padding(.leading, 5)
            }
            self
        }
    }
}

