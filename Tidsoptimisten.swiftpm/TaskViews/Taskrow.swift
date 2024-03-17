//
//  SwiftUIView.swift
//  
//
//  Created by Halfdan Albrecht Isaksen on 06/03/2024.
//

import SwiftUI

struct Taskrow: View {
    let task: OverTask
    let updateSubTask: (UnderTask) -> Void
    let onDelete: () -> Void 

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.name)
                    .font(.headline)
                .padding(.bottom, 2)
                Spacer()
            }
            
            // Loop through each `UnderTask` and display its name and weight
            ForEach(task.subTasks, id: \.id) { underTask in
                Button(action: {
                    updateSubTask(underTask)
                }){
                    HStack {
                        Image(systemName: underTask.taskcompleted ? "checkmark.circle" : "circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.blue)
                        
                        Text(underTask.name)
                            .font(.subheadline)
                            .foregroundStyle(.black)
                        
                        Spacer()
                        Text("\(underTask.weight, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                    .padding(.bottom, 1)
                }
            }
            
            //Show the overall progress of the `OverTask`
            if task.subTasks.count > 0 {
                ProgressView(value: task.progress, total: 1.0)
                    .accentColor(task.progress >= 1.0 ? .green : .blue)
            }
        }.contextMenu {
            Button("Delete") {
                onDelete() // Call the onDelete callback here
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
    
}

#Preview {
    let undertask1 = UnderTask(id: UUID(), name: "Swift student challenge", weight: 0.3, taskcompleted: false)
    let overtask = OverTask(id: UUID(), name: "Programming", progress: 0.6, subTasks: [undertask1], date: Date())
    return Taskrow(task: overtask, updateSubTask: { _ in}, onDelete: { })
}
