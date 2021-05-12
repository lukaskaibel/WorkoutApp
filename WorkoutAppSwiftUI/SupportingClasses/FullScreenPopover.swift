//
//  FullScreenPopover.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 20.04.21.
//

import SwiftUI

struct FullScreenPopover<Content: View>: View {
    
    let content: Content
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
        }
    }
}

struct FullScreenPopover_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenPopover(content: Rectangle().foregroundColor(Color.red).frame(maxHeight: .infinity)).background(Color.green.edgesIgnoringSafeArea(.all))
    }
}
