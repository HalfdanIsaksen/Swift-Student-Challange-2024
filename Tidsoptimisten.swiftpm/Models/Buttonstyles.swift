//
//  Buttonstyles.swift
//
//
//  Created by Halfdan Albrecht Isaksen on 22/02/2024.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.cyan)
            .cornerRadius(8)
           
    }
}
struct GreenButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .padding()
    }
}
