//
//  TimeIterator.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 03.03.21.
//

import Foundation

protocol TimeIteratorDelegate {
    mutating func timeChanged()
}

class TimeIterator {
    
    ///Variable
    
    public var delegate: TimeIteratorDelegate?
    private var timer = Timer(), timeIntervall = 0.1
    
    ///Init
    
    init() {}
    
    init(timeIntervall: Double) {
        self.timeIntervall = timeIntervall
    }
    
    ///Public Methods
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: timeIntervall, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    ///Private Methods
    
    @objc private func timerFired() {
        delegate?.timeChanged()
    }
    
}
