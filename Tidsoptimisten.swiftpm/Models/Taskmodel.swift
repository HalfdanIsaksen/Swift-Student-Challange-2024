//
//  Taskmodel.swift
//  Tidsoptimisten
//
//  Created by Halfdan Albrecht Isaksen on 20/02/2024.
//

import Foundation

struct UnderTask : Identifiable, Hashable, Codable{
    let id : UUID
    var name : String
    var weight : Float
    var taskcompleted : Bool
}

struct OverTask : Identifiable, Hashable, Codable{
    let id : UUID
    var name : String
    var progress: Float
    var subTasks: [UnderTask]
    var date : Date?
}

func createOverTask(id : UUID, name : String, undertasks : [UnderTask]) -> OverTask{
    return OverTask(id: id, name: name, progress: 0.0, subTasks: undertasks)
}

func adjustTaskWeights(in overTask: inout OverTask, withAdjustedTaskId adjustedTaskId: UUID? = nil, adjustedWeight: Float? = nil) {
    let totalWeight: Float = 1.0
    var remainingWeight = totalWeight
    
    // Subtract the weights of tasks that have been explicitly set (excluding the newly adjusted one, if specified)
    for task in overTask.subTasks where task.id != adjustedTaskId && task.weight > 0 {
        remainingWeight -= task.weight
    }
    
    // If one task's weight is being adjusted, apply that adjustment now
    if let adjustedWeight = adjustedWeight, let adjustedTaskId = adjustedTaskId {
        if let index = overTask.subTasks.firstIndex(where: { $0.id == adjustedTaskId }) {
            overTask.subTasks[index].weight = adjustedWeight
            remainingWeight -= adjustedWeight // Ensure to subtract this after the loop to avoid subtracting it twice
        }
    }

    // Calculate the number of tasks that need their weight adjusted (those with 0 weight, excluding the newly adjusted one)
    let tasksNeedingAdjustment = overTask.subTasks.filter { $0.weight == 0.0 && $0.id != adjustedTaskId }
    let weightPerTask = tasksNeedingAdjustment.isEmpty ? 0 : remainingWeight / Float(tasksNeedingAdjustment.count)

    // Adjust the weight for each task that hasn't been explicitly set (and is not the newly adjusted task)
    for i in 0..<overTask.subTasks.count where overTask.subTasks[i].id != adjustedTaskId && overTask.subTasks[i].weight == 0.0 {
        overTask.subTasks[i].weight = weightPerTask
    }
}



func saveTasks(_ overTasks: [OverTask]) {
    let userDefaults = UserDefaults.standard
    do {
        let encodedData = try JSONEncoder().encode(overTasks)
        userDefaults.set(encodedData, forKey: "overTasks")
    } catch {
        print("Unable to encode OverTask (\(error))")
    }
}

func loadTasks() throws -> [OverTask] {
    guard let savedTasksData = UserDefaults.standard.data(forKey: "overTasks") else {
        return []
    }
    
    let decodedTasks = try JSONDecoder().decode([OverTask].self, from: savedTasksData)
    return decodedTasks
}

