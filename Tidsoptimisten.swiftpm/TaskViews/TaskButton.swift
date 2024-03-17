//
//  TaskButton.swift
//  Tidsoptimisten
//
//  Created by Halfdan Albrecht Isaksen on 19/02/2024.
//

import SwiftUI

struct TaskButton: View {
    //Variables
    @State private var name = ""
    @State private var date : Date = .now
    @State private var temporaryDate: Date = Date()
    @State private var createUnderTasks = false
    @State private var undertasks : [UnderTask] = []
    @State private var newOverTask = OverTask(id: UUID(), name: "", progress: 0.0, subTasks: [], date: Date())
    @Binding var tasks : [OverTask]
    @State private var error: Error?
    
    
    var body: some View {
        VStack {
            TextField("Enter the name of your task", text: $newOverTask.name).padding()
            DatePicker(
                "Date",
                selection: $temporaryDate, 
                displayedComponents: .date
            )
            .onChange(of: temporaryDate) { newValue in
                newOverTask.date = newValue
            }
            Button(action: {
                createUnderTasks.toggle()
            }) {
                Text("Create undertask")
            }.buttonStyle(CustomButtonStyle())
            
            if createUnderTasks {
                CreateUnderTaskView(overTask: $newOverTask)
            }
            
            Button("Add task") {
                if !newOverTask.name.isEmpty { // Ensure there's a name before adding
                    adjustTaskWeights(in: &newOverTask)
                    tasks.append(newOverTask)
                    saveTasks(tasks)
                    newOverTask = OverTask(id: UUID(), name: "", progress: 0.0, subTasks: []) // Reset for next use
                }
            }.buttonStyle(CustomButtonStyle())
        }
    }
}

#Preview {
    let overtaskPreviewArray = [OverTask(id: UUID(), name: "Preview Task", progress: 0.5, subTasks: [])]
    return TaskButton(tasks: .constant(overtaskPreviewArray))
}
