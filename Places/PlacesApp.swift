//
//  PlacesApp.swift
//  Places
//
//  Created by Dan Stoakes on 05/08/2021.
//

import SwiftUI
import CoreData

@main
struct PlacesApp: App {
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .inactive || scenePhase == .background {
                saveContext()
            }
        }
    }
    
    func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
