//
//  ColorBackgroundView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 20.04.21.
//

import SwiftUI

struct MovingGradientView: View {
    
    //MARK: Variables
    
    @ObservedObject var movingGradient: MovingGradient
    
    //MARK: Body
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(LinearGradient(gradient: Gradient(colors: movingGradient.colors), startPoint: movingGradient.startPoint, endPoint: movingGradient.endPoint))
            .edgesIgnoringSafeArea(.all)
    }
        
}


struct ColorBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MovingGradient(colors: [.green, .blue], timeIntervall: 5.0).view
    }
}


extension UnitPoint {
    
    static var all: [UnitPoint] {
        [.bottom, .bottomLeading, .bottomTrailing, .center, .leading, .top, .topLeading, .topTrailing, .trailing]
    }
    
    func randomNonOpposing() -> UnitPoint {
        switch self {
        case .bottom, .bottomLeading, .bottomTrailing:
            return [UnitPoint.bottom, .bottomLeading, .bottomTrailing, .leading, .trailing].randomElement()!
        case .top, .topLeading, .topTrailing:
            return [UnitPoint.top, .topLeading, .topTrailing, .leading, .trailing].randomElement()!
        case .leading:
            return [UnitPoint.top, .topLeading, .leading, .bottom, .bottomLeading].randomElement()!
        case .trailing:
            return [UnitPoint.top, .topTrailing, .trailing, .bottom, .bottomTrailing].randomElement()!
        default:
            return UnitPoint.all.randomElement()!
        }
    }
    
}
