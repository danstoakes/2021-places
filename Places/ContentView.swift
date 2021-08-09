//
//  ContentView.swift
//  Places
//
//  Created by Dan Stoakes on 05/08/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.startDate, ascending: false)],
        animation: .default)
    private var places: FetchedResults<Place>
    private var filteredPlaces:[Place] { places.filter { !showingFavouritesOnly || $0.isFavourite }}
    
    @State var showingAddModal: Bool = false
    @State var showingFavouritesOnly: Bool = false
    
    @State var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)

    var body: some View {
        NavigationView {
            placeList
            .navigationTitle("Places")
            .toolbar(content: toolbarContent)
            .sheet(isPresented: $showingAddModal, content: {
                NewPlaceView(showingAddModal: $showingAddModal, completion: { imageData, address1, address2, city, county,
                    postalCode, startDate, endDate, isFavourite, description, latitude, longitude in
                    // need to do some validation
                    let place: Place = Place(context: viewContext)
                    place.id = UUID()
                    place.imageData = imageData
                    place.addressLine1 = address1
                    place.addressLine2 = address2
                    place.city = city
                    place.county = county
                    place.postalCode = postalCode
                    place.startDate = startDate
                    place.endDate = endDate
                    place.isFavourite = isFavourite
                    place.desc = description
                    place.latitude = latitude
                    place.longitude = longitude
                    
                    showingAddModal.toggle()
                    
                    PlacesApp().saveContext()
                })
            })
        }
    }
    
    private var placeList: some View {
        List {
            Toggle(isOn: $showingFavouritesOnly) {
                Text("Favourites only")
            }
            ForEach(filteredPlaces) { place in
                NavigationLink(destination: PlaceView(place: place)) {
                    PlaceRowView(place: place)
                }
            }
                .onDelete(perform: remove)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddModal.toggle() })
            {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .accessibilityLabel("Add item")
            }
        }
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func add() {
        
    }
    
    private func remove(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)
            save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
