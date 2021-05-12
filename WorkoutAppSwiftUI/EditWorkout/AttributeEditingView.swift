//
//  AttributeEditingView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 03.04.21.
//

import SwiftUI

struct AttributeEditingView: View {
    
    //MARK: Variables
    
    @Binding var isPresented: Bool
    @ObservedObject var editor: WorkoutEditor
        
    //MARK: Body
    
    var body: some View {
        ZStack {
            
            //dismisses, when background is tapped
            Color.white.opacity(0.00001)
                .onTapGesture {
                    isPresented = false
                }
            VStack(spacing: 0) {
                /*
                //Attribute Selection Picker (horizontal)
                Picker(selection: $attributeType, label: Text("Attribute Selector"), content: {
                    Text(String(editor.selectedSet.repetitions)).tag(SetAttribute.repetitions)
                    Text(String(editor.selectedSet.weight)).tag(SetAttribute.weight)
                    Text(String(editor.selectedSet.duration)).tag(SetAttribute.duration)
                    Text(String(editor.selectedSet.restAfter)).tag(SetAttribute.restAfter)
                }).pickerStyle(SegmentedPickerStyle())
                */
                //Different Pickers for Attributes
                if editor.selectedAttribute == .repetitions {
                    Picker(selection: $editor.selectedSet.repetitions, label: Text("Repetitions"), content: {
                        ForEach(items, id:\.self) { i in
                            Text(String(i))
                                .foregroundColor(.mutedWhite)
                        }
                    })
                } else if editor.selectedAttribute == .duration {
                    Picker(selection: $editor.selectedSet.duration, label: Text("Duration"), content: {
                        ForEach(items, id:\.self) { i in
                            Text(String(i))
                                .foregroundColor(.mutedWhite)
                        }
                    })
                } else if editor.selectedAttribute == .weight {
                    PickerView(data: [items.map {String($0)}, (0..<8).map { (Float($0)/8.0).fractionToString() }], selections: $editor.weight)
                } else {
                    Picker(selection: $editor.selectedSet.restAfter, label: Text("Rest"), content: {
                        ForEach(items, id:\.self) { i in
                            Text(String(i))
                                .foregroundColor(.mutedWhite)
                        }
                    })
                }
            }
        }.contentShape(Rectangle()) //prevents dismiss when tapping between elements
        .animation(.none)
    }
    
    //MARK: Computed Properies
    
    
    
    
    
    //Items for attribute pickers
    var items: [Int] {
        switch editor.selectedAttribute {
        case .duration, .restAfter: return Int.stride(from: 0, to: 900, with: 5)
        case .repetitions: return Int.stride(from: 0, to: 100, with: 1)
        case .weight: return Int.stride(from: 0, to: 500, with: 1)
        }
    }
    
}

struct AttributeEditingView_Previews: PreviewProvider {
    static var previews: some View {
        AttributeEditingView(isPresented: .constant(true), editor: WorkoutEditor())
    }
}


extension Int {
    
    static func stride(from start: Int, to end: Int, with stride: Int) -> [Int] {
        var result = [Int]()
        for i in start..<end {
            if (i-start) % stride == 0 {
                result.append(i)
            }
        }
        return result
    }
    
}


extension Float {
    
    func fractionToString() -> String {
         switch self {
         case 0.125..<0.126:
             return NSLocalizedString("\u{215B}", comment: "1/8")
         case 0.25..<0.26:
             return NSLocalizedString("\u{00BC}", comment: "1/4")
         case 0.33..<0.34:
             return NSLocalizedString("\u{2153}", comment: "1/3")
         case 0.375..<0.38:
            return NSLocalizedString("\u{215C}", comment: "3/8")
         case 0.5..<0.6:
             return NSLocalizedString("\u{00BD}", comment: "1/2")
         case 0.625..<0.63:
             return NSLocalizedString("\u{215D}", comment: "5/8")
         case 0.66..<0.67:
             return NSLocalizedString("\u{2154}", comment: "2/3")
         case 0.75..<0.76:
             return NSLocalizedString("\u{00BE}", comment: "3/4")
         case 0.875..<0.88:
             return NSLocalizedString("\u{215E}", comment: "7/8")
         default:
            return "\(self)"
         }
     }
    
}


extension String {
    
    static func fraction(numerator: Int, denominator: Int) -> String {
        return "\(NSLocalizedString("\u{2074}", comment: "Numerators - \(numerator)"))\(NSLocalizedString("\u{2044}", comment: "fraction slash"))\(NSLocalizedString("\u{2085}", comment: "Denominator - \(denominator)"))"
    }
    
}


