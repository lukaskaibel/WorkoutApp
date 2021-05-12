//
//  SetGroupDetailView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 17.04.21.
//

import SwiftUI


struct SetGroupDetail: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutEditor: WorkoutEditor
        
    var setGroup: WorkoutSetGroup
    
    //MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(setGroup.exercise?.muscleGroup.rawValue.capitalized ?? "")
                        .font(Font.caption.bold())
                        .foregroundColor(.secondaryMutedWhite)
                    Text(setGroup.exercise?.name.capitalized ?? "No Exercise Selected")
                        .font(Font.title3.bold())
                        .foregroundColor(.mutedWhite)
                }
                Spacer()
                Text("\(setGroup.sets.count)")
                    .font(Font.title3.bold())
                    .foregroundColor(.mutedWhite)
            }.padding()
            .background(Color.translucentDarkGray2)
            ScrollViewReader { proxy in
                List {
                    Group {
                        ForEach(setGroup.sets) { set in
                            VStack(spacing: 5) {
                                HStack {
                                    ValueWithUnitView(value: String(set.repetitions), unit: "rps", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .repetitions ? Color.secondaryMutedWhite : .clear)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                                            workoutEditor.selectedAttribute = .repetitions
                                        }
                                    Rectangle()
                                        .frame(width: 3, height: 25)
                                        .cornerRadius(2.0)
                                        .foregroundColor(.secondaryMutedWhite)
                                    ValueWithUnitView(value: String(set.duration), unit: "s", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .duration ? Color.secondaryMutedWhite : .clear)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            workoutEditor.selectedAttribute = .duration
                                            workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                                        }
                                    Rectangle()
                                        .frame(width: 3, height: 25)
                                        .cornerRadius(2.0)
                                        .foregroundColor(.secondaryMutedWhite)
                                    ValueWithUnitView(value: String(Int(set.weight)), unit: "kg", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .weight ? Color.secondaryMutedWhite : .clear)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                                            workoutEditor.selectedAttribute = .weight
                                        }
                                    Rectangle()
                                        .frame(width: 3, height: 25)
                                        .cornerRadius(2.0)
                                        .foregroundColor(.secondaryMutedWhite)
                                    ValueWithUnitView(value: String(set.restAfter), unit: "s", primaryColor: .mutedWhite, secondaryColor: .secondaryMutedWhite)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(workoutEditor.selectedSetIndex == workoutEditor.workout.sets.firstIndex(of: set)! && workoutEditor.selectedAttribute == .restAfter ? Color.secondaryMutedWhite : .clear)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            workoutEditor.selectedSetIndex = workoutEditor.workout.sets.firstIndex(of: set)!
                                            workoutEditor.selectedAttribute = .restAfter
                                        }
                                }.padding(.vertical, 10)
                                if workoutEditor.selectedSetIndex >= 0, set == workoutEditor.selectedSet {
                                    AttributeEditingView(isPresented: $workoutEditor.setSelected, editor: workoutEditor)
                                        .foregroundColor(.mutedWhite)
                                }
                            }.id(set)
                        }.onDelete(perform: { indexSet in
                            workoutEditor.removeSet(for: setGroup, at: indexSet.first!)
                        })
                        Button(action: { workoutEditor.addSet(for: setGroup) }) {
                            HStack {
                                Spacer()
                                Image.plus
                                Text("Add Set")
                                Spacer()
                            }.font(Font.body.bold())
                            .foregroundColor(.blue)
                        }.contentShape(Rectangle())
                    }
                    .listRowBackground(Color.clear)
                }
                .background(Color.translucentGray)
                .listStyle(DefaultListStyle())
                .onAppear() {
                    if workoutEditor.setSelected {
                        proxy.scrollTo(workoutEditor.selectedSet, anchor: .top)
                    }
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                }
            }
        }
    }
    
}


struct ValueWithUnitView: View {
    
    let value: String
    let unit: String
    
    var primaryColor: Color = .label
    var secondaryColor: Color = .secondaryLabel
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(value)
                .font(Font.body.bold())
                .foregroundColor(primaryColor)
            Text(unit)
                .font(Font.caption.bold())
                .foregroundColor(secondaryColor)
        }
    }
    
}


struct SetGroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SetGroupDetail(workoutEditor: WorkoutEditor(), setGroup: WorkoutSetGroup())
            .background(Color.darkGray)
            .edgesIgnoringSafeArea(.all)
    }
}

