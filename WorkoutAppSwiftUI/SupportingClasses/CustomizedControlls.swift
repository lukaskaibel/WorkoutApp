//
//  CustomizedControlls.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 04.03.21.
//

import SwiftUI


struct ImageButton: View {
    
    let image: Image
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
    
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}



struct AttributeEditorView: View {
    
    @Binding var set: WorkoutSet
    @State var editingAttribute: SetAttribute?
    @State var isAddingExercise: Bool = false
    
    var body: some View {
        HStack(spacing: 50) {
            if let attribute = editingAttribute {
                VStack {
                    HStack {
                        HImageWithText(image: attribute == .repetitions ? .multiply : attribute == .weight ? .weight : .stopwatch, text: attribute.rawValue)
                        Spacer()
                        Button("Done", action: {
                            editingAttribute = nil
                        })
                    }
                    Group {
                        if attribute != .weight {
                            Picker("Attribute", selection: attribute == .repetitions ? $set.repetitions : $set.duration) {
                                let data = attribute == .repetitions ? Int.inRange(from: 0, to: 100) : Int.inRange(from: 0, to: 900, 5)
                                ForEach(data, id: \.self) { item in
                                    Text(String(item) + (attribute == .duration ? " s" : "")).tag(Int(item) )
                                }
                            }
                        } else {
                            Picker("Attribute", selection: $set.weight) {
                                ForEach(Int.inRange(from: 0, to: 500, 5), id: \.self) { item in
                                    Text(String(item) + " kg").tag(Float(item))
                                }
                            }
                        }
                    }
                    .animation(.none)
                }
                .padding(.horizontal)
                .padding(.bottom, -50)
                
            } else {
                CircleImageButton(image: Image.multiply, color: set.repetitions > 0 ? .indigo : .secondaryBackground, action: {
                    editingAttribute = .repetitions
                })

                CircleImageButton(image: Image.weight, color: set.weight > 0 ? .secondaryLabel : .secondaryBackground, action: {
                    editingAttribute = .weight
                })
                    
                CircleImageButton(image: Image.stopwatch, color: set.duration > 0 ? .green : .secondaryBackground, action: {
                    editingAttribute = .duration
                })
            }
        }
    }
    
}


extension Int {
    
    static func inRange(from start: Int, to end: Int,_ stride: Int = 1) -> [Int] {
        var result = [Int]()
        for i in 0...end {
            if i % stride == 0 {
                result.append(i)
            }
        }
        return result
    }
    
}


extension Array where Element: BinaryInteger {
    
    func toFloat() -> [Float] {
        return self.map { Float($0) }
    }
    
}


struct HImageWithText: View {
    
    let image: Image
    let text: String
    
    var body: some View {
        HStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(text)
        }
    }
    
}




struct HDiscriptionCircleButton: View {
    
    let image: Image
    let color: Color
    let discription: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(color)
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10, alignment: .center)
                        .foregroundColor(.white)
                        .font(Font.body.bold())
                }
                Text(discription)
                    .font(Font.body.bold())
                    .foregroundColor(color)
            }
        }
    }
    
}


struct VDiscriptionCircleImageButton: View {
    
    let image: Image
    let color: Color
    let discription: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            CircleImageButton(image: image, color: color, action: action)
            Text(discription)
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundColor(.gray)
        }
    }
    
}


struct CircleImageButton: View {
    
    let image: Image
    let color: Color
    var symbolColor: Color = .white
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(color)
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(symbolColor)
            }
        })
    }
    
}


struct AttributesView: View {
    
    @ObservedObject var workoutEditor: WorkoutEditor
    @Binding var setSelected: Bool
    let set: WorkoutSet
    var setIndex: Int { workoutEditor.workout.sets.firstIndex(of: set) ?? 0 }
    
    var body: some View {
        HStack {
            AttributeCircleView(value: set.repetitions, color: .indigo, symbol: .multiply, einheit: "rps", labelColor: labelColor, secondaryLabelColor: secondaryLabelColor)
                .onTapGesture {
                    workoutEditor.selectedSetIndex = setIndex
                    workoutEditor.selectedAttribute = .repetitions
                    setSelected = true
                }
            VDevider()
            AttributeCircleView(value: Int(set.weight), color: .gray, symbol: .weight, einheit: "kg", labelColor: labelColor, secondaryLabelColor: secondaryLabelColor)
                .onTapGesture {
                    workoutEditor.selectedSetIndex = setIndex
                    workoutEditor.selectedAttribute = .weight
                    setSelected = true
                }
            VDevider()
            AttributeCircleView(value: set.duration, color: .green, symbol: .stopwatch, einheit: "s", labelColor: labelColor, secondaryLabelColor: secondaryLabelColor)
                .onTapGesture {
                    workoutEditor.selectedSetIndex = setIndex
                    workoutEditor.selectedAttribute = .duration
                    setSelected = true
            }
            VDevider()
            AttributeCircleView(value: set.restAfter, color: .orange, symbol: .hourglass, einheit: "s", labelColor: labelColor, secondaryLabelColor: secondaryLabelColor)
                .onTapGesture {
                    workoutEditor.selectedSetIndex = setIndex
                    workoutEditor.selectedAttribute = .restAfter
                    setSelected = true
                }
        }.frame(height: 50)
    }
    
    //MARK: Computed Variables
    
    var labelColor: Color { workoutEditor.isExecuting ? .mutedWhite : .label }
    var secondaryLabelColor: Color { workoutEditor.isExecuting ? .secondaryMutedWhite : .secondaryLabel }
    
}


struct AttributeCircleView: View {
    
    let value: Int
    let color: Color
    let symbol: Image
    let einheit: String
    
    var labelColor: Color = .label
    var secondaryLabelColor: Color = .secondaryLabel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            symbol
                .font(Font.caption.bold())
                .foregroundColor(secondaryLabelColor)
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(String(value))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(labelColor)
                Text(einheit)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(secondaryLabelColor)
            }
        }
        .padding()
    }
    
    //MARK: - Graphical Constants
    
    let widthHeight: CGFloat = CGFloat(70)
    
}


struct VDevider: View {
    
    var body: some View {
        Rectangle()
            .frame(width: width)
            .cornerRadius(width/2)
    }
    
    //MARK: Graphic Variables
    
    let width = CGFloat(1)
    
}


struct PageIndicatorView: View {
    
    let numPages: Int
    let currentIndex: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numPages, id:\.self) { i in
                Circle()
                    .foregroundColor(currentIndex == i ? .label : .secondaryLabel)
                    .frame(width: circleWidth)
            }
        }
    }
    
    //MARK: - Grphical Constants
    
    let circleWidth = CGFloat(7)
    
}


struct SegmentedProgressBar: View {
    
    let progress: Int
    var progressInCurrentSegment: Double = 1.0
    let maximum: Int
    var accentColor = Color.secondaryLabel
    var backgroundColor = Color.secondaryBackground
    
    var body: some View {
        if maximum > 0 {
            HStack(spacing:4) {
                ForEach(1...maximum, id: \.self) { i in
                    RectangularProgressView(progress: i < progress ? 1.0 : i == progress ? progressInCurrentSegment : 0.0, accentColor: accentColor, backgroundColor: backgroundColor)
                }
            }
            .frame(height: height)
            .cornerRadius(height)
        }
    }
    
    //MARK: - Graphical Constants
    
    let height = CGFloat(4)
    
}


struct RectangularProgressView: View {
    
    let progress: Double
    let accentColor: Color
    var backgroundColor: Color = .white
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: geometry.size.width * abs(CGFloat(progress)), height: geometry.size.height)
                    .foregroundColor(accentColor)
                Rectangle()
                    .frame(width: geometry.size.width * abs(CGFloat(1 - progress)), height: geometry.size.height)
                    .foregroundColor(backgroundColor)
            }
            .animation(.linear(duration: intervall))
        }
    }
    
    // MARK: - Graphical Constants
    
    let intervall = 0.1     //set this to the intervall in which the view is updated, to smoothen out the animation
    
}


struct TimeView: View {
    
    let time: Double
    private var miliseconds: Int { Int(time*100) % 60 }
    private var seconds: Int { Int(time) % 60 }
    private var minutes: Int { Int(time) / 60 }
    var showMiliseconds = true
    
    var body: some View {
        if showMiliseconds {
            Text(String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds) + ":" + String(format: "%02d", miliseconds))
        } else {
            Text(String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds))
        }
    }
    
}


struct CustomizedControlls_Previews: PreviewProvider {
    
    
    static var previews: some View {
        VStack(spacing: 50) {
            PageIndicatorView(numPages: 4, currentIndex: 2)
            AttributesView(workoutEditor: WorkoutEditor(), setSelected: .constant(true), set: WorkoutSet())
        }
        
    }
}


