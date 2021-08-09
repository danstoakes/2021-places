//
//  PlacesViewModel.swift
//  Places
//
//  Created by Dan Stoakes on 05/08/2021.
//

import SwiftUI

class PlacesViewModel: ObservableObject {
    @Published private var model = PlacesModel()
    
    func fetch() -> FetchedResults<Place> {
        model.fetch()
    }
    
    func add() {
        let place: Place = Place(context: model.viewContext)
        place.id = UUID()
        place.imageData = UIImage(systemName: "plus")?.jpegData(compressionQuality: 1.0)
        place.addressLine1 = "The School House, Seion Chapel"
        place.addressLine2 = "Ambrose Street"
        place.city = "Bangor"
        place.county = "Gwynedd"
        place.postalCode = "LL57 1HB"
        place.startDate = Date()
        place.endDate = Date()
        place.latitude = 10.0
        place.longitude = 11.0
        
        model.save()
    }
    
    func remove() {
        
    }
    
    func update() {
        
    }
}
