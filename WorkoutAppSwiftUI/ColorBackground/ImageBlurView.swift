//
//  ImageBlurView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 01.05.21.
//

import SwiftUI

struct DarkImageBlurView: View {
    
    let image: Image
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.5)
                .blur(radius: 150)
            Color.translucentGray
        }
    }
}

struct ImageBlurView_Previews: PreviewProvider {
    static var previews: some View {
        DarkImageBlurView(image: Image("workout"))
            .edgesIgnoringSafeArea(.all)
    }
}
