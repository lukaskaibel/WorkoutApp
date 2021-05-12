//
//  ColorBackground.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 20.04.21.
//

import SwiftUI


class MovingGradient: ObservableObject, TimeIteratorDelegate {
    
    //MARK: Variables
    
    @Published var startPoint: UnitPoint = UnitPoint.all.randomElement()!
    @Published var endPoint: UnitPoint = UnitPoint.all.randomElement()!
    
    lazy var view: MovingGradientView = MovingGradientView(movingGradient: self)
    
    let colors: [Color]
    let timeIntervall: Double
    private let timeIterator: TimeIterator
    
    //MARK: Init
    
    init(colors: [Color], timeIntervall: Double) {
        self.colors = colors
        self.timeIntervall = timeIntervall
        self.timeIterator = TimeIterator(timeIntervall: timeIntervall)
        self.timeIterator.delegate = self
        self.timeIterator.start()
        self.timeChanged()
    }
    
    //MARK: Public Methods
    
    func timeChanged() {
        withAnimation(.easeInOut(duration: timeIntervall)) {
            startPoint = {
                var tmpPoint = startPoint.randomNonOpposing()
                while tmpPoint == endPoint {
                    tmpPoint = startPoint.randomNonOpposing()
                }
                return tmpPoint
            }()
            endPoint = {
                var tmpPoint = endPoint.randomNonOpposing()
                while tmpPoint == startPoint {
                    tmpPoint = endPoint.randomNonOpposing()
                }
                return tmpPoint
            }()
        }
    }
    
}
