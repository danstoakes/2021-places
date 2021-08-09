//
//  PlacesModel.swift
//  Places
//
//  Created by Dan Stoakes on 05/08/2021.
//

import SwiftUI
import Foundation

struct PlacesModel {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.startDate, ascending: false)],
        animation: .default)
    private var places: FetchedResults<Place>
    
    func fetch() -> FetchedResults<Place> {
        places
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription + " :(")
            }
        }
    }
    
    private func update() {
        
    }
}
