//
//  PlaceViewModel.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI
import Foundation
import CoreData

class PlaceViewModel: ObservableObject {
    @Published private var places: FetchedResults<Place>
    
    init (places: FetchedResults<Place>) {
        self.places = places
    }
}
