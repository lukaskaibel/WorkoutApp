//
//  SmallPopover.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 13.04.21.
//

import SwiftUI

struct SmallPopover<Content: View>: View {
    
    @Binding var isPresented: Bool
    
    let content: Content
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.translucentGray
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
            }
            content
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark)))
                .cornerRadius(20)
                .padding(40)
        }.shadow(radius: 10)
    }
}


struct SmallPopoverBlur<Content: View>: View {
    
    @Binding var isPresented: Bool
    
    let content: Content
    
    var body: some View {
        ZStack {
            if isPresented {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
            }
            content
                .cornerRadius(30)
                .padding()
                .shadow(radius: 10)
        }
    }
}


struct SmallPopover_Previews: PreviewProvider {
    static var previews: some View {
        SmallPopover(isPresented: .constant(true), content: Text("Hallo"))
    }
}
