//
//  SwiftUIView.swift
//  
//
//  Created by Halfdan Albrecht Isaksen on 25/02/2024.
//

import SwiftUI

struct TodoCalendar: View {
    @State private var selectedDate: Date?
    @State private var tasksForSelectedDate: [OverTask] = []
    @State private var tasks: [OverTask] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    CustomCalendar(interval: DateInterval(start: .distantPast, end: .distantFuture),
                                   tasks: tasksForSelectedDate,
                                   selectedDate: $selectedDate)
                    .onChange(of: selectedDate) { newValue in
                        if let newDate = newValue {
                            tasksForSelectedDate = tasks.filter { $0.date?.isSameDay(as: newDate) ?? false }
                        } else {
                            tasksForSelectedDate = []
                        }
                        print("loaded tasks: \(tasksForSelectedDate)")
                        //print(selectedDate ?? "No date selected")
                    }
                }
                
                // List the tasks for the selected date
                Taskdisplay(tasks: $tasksForSelectedDate)
            }
        }
        .onAppear {
            do {
                tasks = try loadTasks()
            } catch {
                print("Failed to load tasks: \(error.localizedDescription)")
            }
        }
    }
}




extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
           let calendar = Calendar.current
           return calendar.isDate(self, inSameDayAs: otherDate)
       }
}

#Preview {
    TodoCalendar()
}
