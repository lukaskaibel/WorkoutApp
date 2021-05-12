//
//  UIData.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 30.04.21.
//

import SwiftUI


class UserData: ObservableObject, RawRepresentable, Codable {
    
    //MARK: Variables
    
    @Published var favoriteExercises: [Exercise] = [Exercise]()
    @Published var workoutImages: [Workout:Image] = [Workout:Image]()
    @Published var workoutColors: [Workout:[Color]] = [Workout:[Color]]()
    @Published var workoutIntros: [Workout:URL] = [Workout:URL]()
    @Published var workoutOutros: [Workout:URL] = [Workout:URL]()


    //MARK: Public Methods

    func favoriteTapped(for exercise: Exercise) {
        if favoriteExercises.contains(exercise) {
            favoriteExercises = favoriteExercises.filter { $0 != exercise }
        } else {
            favoriteExercises.append(exercise)
        }
    }
    
    
    @ViewBuilder
    func thumbnail(for workout: Workout) -> some View {
        //Workout has stored Image
        if let image = workoutImages[workout] {
            image
                .resizable()
        }
        //Workout does'nt have stored Image -> Generate Gradient View With Symbol
        else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.lightGreen, .blue]), startPoint: .topTrailing, endPoint: .bottom)
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                            HStack {
                                Spacer()
                                self.symbol(for: workout)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height * 2/3)
                                    .opacity(0.2)
                                Spacer()
                            }
                        Spacer()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func introView(for workout: Workout, isMuted: Bool = false) -> some View {
        if let url = workoutIntros[workout] {
            LoopingPlayer(url: url, isMuted: isMuted)
        } else {
            thumbnail(for: workout)
        }
    }
    
    func symbol(for workout: Workout) -> Image {
        switch workout.type {
        case .push: return .pushup
        case .pull: return .pullup
        case .endurance: return .running
        case .legs: return .squat
        case .core: return .crunch
        default: return .fullBody
        }
    }
    
    
    func colors(for workout: Workout) -> [Color] {
        if let colors = workoutColors[workout] {
            return colors
        } else {
            return [.lightGreen, .blue]
        }
    }
    
    
    //MARK: Init & Storing Mechanism
    
    init() {
        
    }
    
    required init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(UserData.self, from: data)
        else {
            return nil
        }
        self.favoriteExercises = result.favoriteExercises
    }

    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
}
