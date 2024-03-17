//
//  CreateUnderTaskView.swift
//  Tidsoptimisten
//
//  Created by Halfdan Albrecht Isaksen on 20/02/2024.
//

import SwiftUI

struct CreateUnderTaskView: View {
    @Binding var overTask: OverTask // Now binding to OverTask
    @State private var taskloadString = ""
    @State private var taskload: Float = 0.0
    @State private var taskname = ""
    
    var body: some View {
        VStack {
            TextField("Enter the name of the undertask", text: $taskname).padding()
            TextField("Enter task load", text: $taskloadString) {
                // Logic to validate and set task load
            }.padding()
            Button("Add undertask") {
                taskload = Float(taskloadString) ?? 0.0
                let newTaskID = UUID()
                let newUnderTask = UnderTask(id: newTaskID, name: taskname, weight: taskload, taskcompleted: false)
                overTask.subTasks.append(newUnderTask)
                //adjustTaskWeights(in: &overTask, withAdjustedTaskId: newTaskID, adjustedWeight: taskload)
                // Call to adjust weights here, assuming it's now part of OverTask or accessible here
                taskname = ""
                taskload = 0
                taskloadString = ""
            }.buttonStyle(CustomButtonStyle())
        }
    }

}


#Preview {
    //For testing
    let overtaskPreview = OverTask(id: UUID(), name: "TestPreview", progress: 0.0, subTasks: [])
    return CreateUnderTaskView(overTask: .constant(overtaskPreview))
    //CreateUnderTaskView()
}
