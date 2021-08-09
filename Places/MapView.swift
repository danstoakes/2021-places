//
//  MapView.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude: Double
    var longitude: Double
    
    @State private var region = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region)
            .ignoresSafeArea(edges: .top)
            .frame(height: 250)
            .onAppear {
                setRegion(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct Address {
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var county: String = ""
    var postalCode: String = ""
    var country: String = "United Kingdom" // assumed
    
    var address: String = ""
    
    mutating func getAddressString() -> String {
        let addressComponents: Array<String> = [addressLine1, addressLine2, city, county, postalCode]
        
        addressComponents.indices.forEach { address += !addressComponents[$0].isEmpty ? addressComponents[$0] + ", " : "" }
        address += country
        
        return address
    }
    
    mutating func isAdequatelyFormed() -> Bool {
        // i.e, accept 83 Trinity Street, Fareham, Hampshire, United Kingdom
        //      deny 15 Well Street, Bangor, United Kingdom
        return getAddressString().countInstances(of: ",") > 2
    }
}

extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
}
