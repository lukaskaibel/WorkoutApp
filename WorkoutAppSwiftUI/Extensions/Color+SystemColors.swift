//
//  Color+SystemColors.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.03.21.
//

import SwiftUI


extension Color {
    
    static var secondaryLabel: Color { Color(UIColor.secondaryLabel) }
    static var neonYellow: Color { Color("NeonYellow") }
    static var background: Color { Color(UIColor.systemBackground) }
    static var secondaryBackground: Color { Color(UIColor.secondarySystemBackground) }
    static var tertiaryBackground: Color { Color(UIColor.tertiarySystemBackground) }
    static var appColor: Color { neonYellow }
    static var indigo: Color { Color(UIColor.systemIndigo) }
    static var selection: Color { Color.blue }
    static var lightGreen: Color { Color("lightGreen") }
    static var lightGray: Color { Color("lightGray") }
    static var darkGray: Color { Color("darkGray") }
    static var translucentGray: Color { Color.black.opacity(0.3) }
    static var translucentDarkGray: Color { Color.black.opacity(0.7) }
    static var translucentDarkGray2: Color { Color.black.opacity(0.5) }
    static var translucentBlack: Color { Color.black.opacity(0.9) }
    static var label: Color { Color(UIColor.label) }
    static var mutedWhite: Color { Color.white.opacity(0.9) }
    static var secondaryMutedWhite: Color { Color.white.opacity(0.5) }

    
    static func color(for attribute: SetAttribute) -> Color {
        switch attribute {
        case .duration: return .green
        case .repetitions: return .indigo
        case .weight: return .gray
        default: return .orange
        }
    }
    
}


extension UIColor {
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    var redGreenDifference: Float { Float(abs(rgba.red - rgba.green)) }
    var redBlueDifference: Float { Float(abs(rgba.red - rgba.blue)) }
    var blueGreenDifference: Float { Float(abs(rgba.blue - rgba.green)) }
    
    func onGrayScaleFactor() -> Float {
        return redGreenDifference + redBlueDifference + blueGreenDifference
    }
    
}
