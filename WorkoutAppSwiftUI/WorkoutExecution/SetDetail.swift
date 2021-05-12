//
//  SetDetail.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 11.03.21.
//

import SwiftUI

struct SetDetail: View {
    
    @ObservedObject var workoutExecution: WorkoutExecution
    
    var body: some View {
        VStack {
            Spacer()
            AttributeTileViews(workoutExecution: workoutExecution, set: workoutExecution.currentSet)
                .padding()
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text(workoutExecution.currentSet.exercise.name.capitalized)
                        .font(Font.title3.bold())
                        .foregroundColor(.mutedWhite)
                    Text(workoutExecution.currentSet.exercise.muscleGroup.rawValue.capitalized)
                        .font(Font.body)
                        .foregroundColor(.secondaryMutedWhite)
                }
                Spacer()
            }.padding()
        }
    }
    
}


struct AttributeTileViews: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutExecution: WorkoutExecution
    
    let set: WorkoutSet
    
    //MARK: Body

    var body: some View {
        VStack(spacing: 20) {
            AttributeTile(content: TimeView(time: workoutExecution.time, showMiliseconds: false).font(Font.largeTitle.bold().monospacedDigit()), attribute: .duration)
                .frame(maxHeight: 130)
            HStack(spacing: 20) {
                AttributeTile(content: Text(String(workoutExecution.currentSet.repetitions)), attribute: .repetitions)
                AttributeTile(content: Text(String(format: "%.1f", workoutExecution.currentSet.weight)), attribute: .weight)
                
            }.frame(maxHeight: 120)
        }.foregroundColor(.white)
        .frame(alignment: .center)
    }
    
}


struct AttributeTile<Content: View>: View {
    
    //MARK: Variables
    
    let content: Content
    let attribute: SetAttribute
    var symbol: Image {
        .symbol(for: attribute)
    }
    var color: Color {
        .color(for: attribute)
    }
    
    //MARK: Body
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack {
                    symbol
                        .font(Font.caption.bold())
                        .foregroundColor(.secondaryMutedWhite)
                    Spacer()
                }
                content
                    .font(Font.title.bold())
                Text("")
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(Color.translucentDarkGray2)
        .cornerRadius(cornerRadius)
    }
    
    //MARK: Graphical Constants
    
    let cornerRadius = CGFloat(20.0)
    
}


struct CircleContentView: View {
    
    var accentColor: Color = .black
    let image: Image
    let text: String
    var percentage: Double
    
    var body: some View {
        ZStack {
            CircleView(accentColor: accentColor, percentage: percentage)
            VStack(spacing: 8) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                Text(text)
                    .font(.title3).bold()
            }
        }
    }
    
}


struct CircleTimeView: View {
    
    let time: Double
    let percentage: Double
    
    var body: some View {
        ZStack {
            CircleView(accentColor: .green, percentage: percentage)
            VStack(spacing: 15) {
                Image.stopwatch
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                TimeView(time: time)
                    .font(Font.system(.title).bold().monospacedDigit())
            }
        }
    }
    
}


struct CircleView: View {
    
    var accentColor: Color = .black
    var percentage: Double
        
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(accentColor.opacity(0.5))
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage + percentageOffset))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .rotation(.degrees(-90.0))
                .foregroundColor(accentColor)
        }
    }
    
    // MARK: - Graphical Constants
    
    let lineWidth = CGFloat(8.0)
    let percentageOffset = 0.01
    
}
struct SetDetail_Previews: PreviewProvider {
    static var previews: some View {
        SetDetail(workoutExecution: WorkoutExecution(workout: Workout.testWorkouts[0]))
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
    }
}
