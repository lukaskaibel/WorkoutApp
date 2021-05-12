//
//  AddExerciseView.swift
//  WorkoutAppSwiftUI
//
//  Created by Lukas Kaibel on 23.03.21.
//

import SwiftUI

struct AddExerciseView: View {
    
    //MARK: Variables
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool
    
    @StateObject var exerciseAdder: ExerciseAdder
    @ObservedObject var uiData: UserData
    
    @State var isSearchingForExercise = false
        
    init(isPresented: Binding<Bool>, exerciseAdder: ExerciseAdder) {
        self._isPresented = isPresented
        self._exerciseAdder = StateObject(wrappedValue: exerciseAdder)
        self.uiData = userData
    }
            
    //MARK: Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                //Filtered Exercise List
                exerciseList
            }.navigationBarItems(leading:
                                    Button("Cancel", action: { isPresented = false }),
                                 trailing:
                                    Button(action: { exerciseAdder.addSelected(); isPresented = false }) {
                                        HStack(spacing: 0) {
                                            Text("Add")
                                            if !exerciseAdder.selectedExercises.isEmpty {
                                                Text(" \(exerciseAdder.selectedExercises.count)")
                                            }
                                        }
                                    }
                                    .foregroundColor(exerciseAdder.selectedExercises.count > 0 ? .blue : .gray))
            .navigationTitle("Add Exercise")
        }.navigationViewStyle(StackNavigationViewStyle())
        .onTapGesture {
            isSearchingForExercise = false
            hideKeyboard()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //MARK: Supporting Views
    
    private var searchBarHeader: some View {
        SearchBar(text: $exerciseAdder.searchedText, placeholder: "Seach in Exercises", isEditing: $isSearchingForExercise)
    }
    
    private var muscleGroupSelectionList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                Spacer(minLength: 20)
                Button("All", action: {
                    exerciseAdder.filterMuscleGroup = nil
                })
                    .font(Font.caption.bold())
                    .foregroundColor(exerciseAdder.filterMuscleGroup == nil ? Color.white : .selection)
                    .padding(8)
                    .background(exerciseAdder.filterMuscleGroup == nil ? Color.selection : .clear)
                    .clipShape(Capsule())
                ForEach(MuscleGroup.allCases) { muscleGroup in
                    Button(muscleGroup.rawValue.capitalized, action: {
                        exerciseAdder.tappedFilter(with: muscleGroup)
                    })
                        .font(Font.caption.bold())
                        .foregroundColor(muscleGroup == exerciseAdder.filterMuscleGroup ? Color.white : .selection)
                        .padding(8)
                        .background(muscleGroup == exerciseAdder.filterMuscleGroup ? Color.selection : .clear)
                        .clipShape(Capsule())
                }
                Spacer(minLength: 20)
            }
        } .frame(height: 40)
    }
    
    private var exerciseList: some View {
        ScrollView(.vertical) {
            LazyVStack {
                Section(header: searchBarHeader) {}
                Section(header: muscleGroupSelectionList) {
                    if !favoriteFilteredExercises.isEmpty {
                        Section(header: Header(title: "Favorites").padding(.horizontal)) {
                            ForEach(favoriteFilteredExercises) { exercise in
                                VStack(spacing: 0) {
                                    ExerciseSelectionView(exercise: exercise, isSelected: exerciseAdder.selectedExercises.contains(exercise))
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            if exerciseAdder.selectedExercises.contains(exercise) { exerciseAdder.remove(selection: exercise) }
                                            else { exerciseAdder.add(selection: exercise) }
                                        }
                                        .contextMenu(menuItems: {
                                            Button(action: {
                                                uiData.favoriteTapped(for: exercise)
                                            }, label: {
                                                HStack {
                                                    Text("Favorite")
                                                    uiData.favoriteExercises.contains(exercise) ? Image.starFill : .star
                                                }
                                            })
                                        })
                                    Divider()
                                        .padding(.leading)
                                }.id(exercise.id + 10000)
                            }
                        }
                    }
                    Section(header: Header(title: "All\(exerciseAdder.filterMuscleGroup != nil ? " Filtered" : "")").padding(.horizontal)) {
                        ForEach(exerciseAdder.filteredExercises) { exercise in
                            VStack(spacing: 0) {
                                ExerciseSelectionView(exercise: exercise, isSelected: exerciseAdder.selectedExercises.contains(exercise))
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        if exerciseAdder.selectedExercises.contains(exercise) { exerciseAdder.remove(selection: exercise) }
                                        else { exerciseAdder.add(selection: exercise) }
                                    }
                                    .contextMenu(menuItems: {
                                        Button(action: {
                                            uiData.favoriteTapped(for: exercise)
                                        }, label: {
                                            HStack {
                                                Text("Favorite")
                                                uiData.favoriteExercises.contains(exercise) ? Image.starFill : .star
                                            }
                                        })
                                    })
                                Divider()
                                    .padding(.leading)
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(uiData)
    }
    
    private struct Header: View {
        
        let title: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(Font.title2.bold())
                Spacer()
            }
        }
        
    }
    
    //Computed Properties
    
    var favoriteFilteredExercises: [Exercise] {
        exerciseAdder.filteredExercises.filter { uiData.favoriteExercises.contains($0) }
    }
   
}


struct ExerciseSelectionView: View {
    
    //MARK: Variables
    
    @EnvironmentObject var uiData: UserData
    
    @State private var showingExerciseDetail = false
    
    let exercise: Exercise
    let isSelected: Bool
    
    //MARK: Body
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .lastTextBaseline) {
                    Text(exercise.name.capitalized)
                        .multilineTextAlignment(.leading)
                        .font(Font.body)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    if uiData.favoriteExercises.contains(exercise) {
                        Image.starFill
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.yellow)
                    }
                }
                Text(exercise.muscleGroup.rawValue.capitalized)
                    .foregroundColor(.gray)
                    .font(Font.caption)
            }
            Spacer()
            (isSelected ? Image.checkmarkCircle.foregroundColor(.blue) : Image.circle.foregroundColor(.secondaryLabel))
                .font(.title)
                
        }.padding(.vertical, 10)
        .contentShape(Rectangle())
    }
    
}


struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(isPresented: .constant(true), exerciseAdder: ExerciseAdder(workoutEditor: WorkoutEditor()))
    }
}



extension ScrollView {
    
    public func fixFlickering() -> some View {
        
        return self.fixFlickering { (scrollView) in
            
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        
        GeometryReader { geometryWithSafeArea in
            GeometryReader { geometry in
                configurator(
                ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                    AnyView(
                    VStack {
                        self.content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
