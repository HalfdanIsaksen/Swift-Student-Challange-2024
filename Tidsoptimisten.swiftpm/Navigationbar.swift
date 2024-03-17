//
//  Navigationbar.swift
//  Tidsoptimisten
//
//  Created by Halfdan Albrecht Isaksen on 21/02/2024.
//

import SwiftUI

struct Navigationbar: View {
    @State private var tasks: [OverTask] = []

    var body: some View {
        NavigationView {
            TabView{
                TodoCalendar()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                }
                Taskdisplay(tasks: $tasks)
                    .tabItem{
                        Label("Tasks", systemImage: "list.clipboard")
                }
            }.onAppear{loadTasksSafely()}
        }
    }    
    private func loadTasksSafely() {
        do {
            tasks = try loadTasks()
        } catch {
            print("Failed to load tasks: \(error)")
            tasks = [] // Consider showing an error message to the user
        }
    }
}

#Preview {
    Navigationbar()
}
