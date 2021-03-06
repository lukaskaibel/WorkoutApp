//
//  SetListView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 12.03.21.
//

import SwiftUI

struct SetGroupList: View {
    
    //MARK: Variables
    
    @ObservedObject var workoutEditor: WorkoutEditor
    
    var onTapOfSetGroup: (WorkoutSetGroup) -> Void
    
    var primaryColor: Color = .label
    var secondaryColor: Color = .secondaryLabel
    
    @State var isAdding: Bool = false
    @State var dragOver: Bool = false
    
    @State var dragging: WorkoutSetGroup?
    
    //MARK: Body
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(workoutEditor.workout.setGroups) { setGroup in
                SetGroupCell(setGroup: setGroup, primaryColor: primaryColor, secondaryColor: secondaryColor)
                    .padding(.vertical, 10)
                    .onDelete {
                        workoutEditor.removeSetGroup(setGroup)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onTapOfSetGroup(setGroup)
                    }
                    .overlay(dragging == setGroup ? Color.translucentGray : .clear)
                    .onDrag {
                        self.dragging = setGroup
                        return NSItemProvider(object: String(setGroup.id) as NSString)
                    }
                    .onDrop(of: [.text], delegate: DragRelocateDelegate(item: setGroup, listData: $workoutEditor.workout.setGroups, current: $dragging))
                Divider()
                    .padding(.leading)
            }
        }
    }
    
}




struct DragRelocateDelegate: DropDelegate {
    let item: WorkoutSetGroup
    @Binding var listData: [WorkoutSetGroup]
    @Binding var current: WorkoutSetGroup?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}



struct SetGroupCell: View {
    
    @ObservedObject var uiData: UserData
    
    @State var addingVideo = false
    
    let setGroup: WorkoutSetGroup
    
    var primaryColor: Color = .label
    var secondaryColor: Color = .secondaryLabel
    
    init(setGroup: WorkoutSetGroup, primaryColor: Color = .label, secondaryColor: Color = .secondaryLabel) {
        self.setGroup = setGroup
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.uiData = userData
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(setGroup.exercise?.name.capitalized ?? "No Exercise Selected")
                        .font(Font.body)
                        .foregroundColor(primaryColor)
                    if uiData.exerciseVideos.keys.contains(setGroup.exercise ?? Exercise()) {
                        Image.video
                            .foregroundColor(.secondaryLabel).font(.caption)
                    }
                }
                Text(setGroup.exercise?.muscleGroup.rawValue.capitalized ?? "")
                    .font(Font.caption)
                    .foregroundColor(secondaryColor)
            }.contextMenu(menuItems: {
                Button(action: {
                    if let exercise = setGroup.exercise {
                        uiData.favoriteTapped(for: exercise)
                    }
                }, label: {
                    HStack {
                        Text("Favorite")
                        uiData.favoriteExercises.contains(setGroup.exercise ?? Exercise()) ? Image.starFill : .star
                    }
                })
            })
            Spacer()
            Text("\(setGroup.sets.count)")
                .font(Font.body.bold())
                .foregroundColor(primaryColor)
            Menu(content: {
                Button(action: {
                    if let exercise = setGroup.exercise {
                        uiData.favoriteTapped(for: exercise)
                    }
                }, label: {
                    HStack {
                        Text("Favorite")
                        uiData.favoriteExercises.contains(setGroup.exercise ?? Exercise()) ? Image.starFill : .star
                    }
                })
                Button(action: {
                    addingVideo = true
                }, label: {
                    HStack {
                        Text("Add Clip")
                        Image.video
                    }
                })
            }, label: {
                Image.dots
                    .foregroundColor(.secondaryLabel)
                    .padding(.vertical)
            })
        }.padding(.horizontal)
        .padding(.vertical, 10)
        .cornerRadius(10.0)
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $addingVideo, content: {
            VideoPickerView(sourceType: .photoLibrary, onVideoPicked: { url in
                uiData.add(videoURL: url, for: setGroup.exercise!)
            }, maxClipLength: Constant.maxExerciseClipLength)
        })
    }
}



struct SetListView_Previews: PreviewProvider {
    static var previews: some View {
        SetGroupList(workoutEditor: WorkoutExecution(workout: Workout.testWorkouts[0]), onTapOfSetGroup: { _ in })
    }
}
