//
//  SwiftUIView.swift
//
//
//  Created by Halfdan Albrecht Isaksen on 21/02/2024.
//

import SwiftUI

struct Taskdisplay: View {
    @Binding var tasks: [OverTask]
    @State private var error: Error?
    @State private var showCreateTask = false
    
    var body: some View {
        ScrollView {
            if let error {
                Text("Error: \(error.localizedDescription)")
                    .padding()
            }
            
            if(tasks.isEmpty) {
                Text("No tasks yet")
            } else {
                VStack(alignment: .leading)
                {
                    ForEach(tasks, id: \.self) { task in
                        Taskrow(task: task,
                                updateSubTask: {subTask in self.updateSubTask(subTask)}, onDelete: {self.delete(task: task)})
                        .padding(10)
                    }
                }
            }
            
        }
        .overlay(alignment: .bottomTrailing) {
            ZStack {
                Spacer()
                Button("Create task") {
                    showCreateTask = true
                }
                .buttonStyle(CustomButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCreateTask){
            TaskButton(tasks: $tasks)
        }
    }
    
    func delete(task: OverTask) {
        withAnimation {
            tasks.removeAll(where: { $0.id == task.id})
        }
        saveTasks(tasks)
    }
    
    func updateSubTask(_ subTaskToModify: UnderTask) {
        guard let indexOfOverTask = tasks.firstIndex(where: { overTask in
            overTask.subTasks.contains(where: { $0.id == subTaskToModify.id })
        }) else {
            return // If the overtask containing the subtask isn't found, return early.
        }

        var newSubTasks = tasks[indexOfOverTask].subTasks
        var totalCompletedProgress: Float = 0.0
        
        if let indexOfSubTask = newSubTasks.firstIndex(where: { $0.id == subTaskToModify.id }) {
            newSubTasks[indexOfSubTask].taskcompleted.toggle()
        }

        // Recalculate progress for the current OverTask
        for subTask in newSubTasks {
            if subTask.taskcompleted {
                totalCompletedProgress += subTask.weight
            }
        }

        // Update the OverTask with the new subtasks and progress
        var updatedOverTask = tasks[indexOfOverTask]
        updatedOverTask.subTasks = newSubTasks
        updatedOverTask.progress = totalCompletedProgress / updatedOverTask.subTasks.map { $0.weight }.reduce(0, +)
        
        withAnimation {
            tasks[indexOfOverTask] = updatedOverTask
            saveTasks(tasks)
        }
    }
}

#Preview {
    let overtaskPreviewArray = [OverTask(id: UUID(), name: "Preview Task", progress: 0.5, subTasks: [])]
    return Taskdisplay(tasks: .constant(overtaskPreviewArray))
}
