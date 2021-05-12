//
//  NavbarWithImage.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 05.04.21.
//

import SwiftUI

struct NavbarWithImage: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString

    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
}
