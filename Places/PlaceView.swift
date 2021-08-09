//
//  PlaceView.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI

struct PlaceView: View {
    @ObservedObject var place : Place
    
    var body: some View {
        ScrollView {
            MapView(latitude: place.latitude, longitude: place.longitude)
            CircleImage(image: Image(uiImage: uiImage))
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                generalInformation
                Divider()
                tenancyDuration
                Divider()
                descriptionInformation
            }
            .padding()
        }
        .navigationTitle(place.addressLine1!)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var uiImage : UIImage
    {
        if let data = place.imageData {
            if let uiImage = UIImage(data: data) {
                return uiImage
            }
            return UIImage(named: "DefaultImage")!
        } else {
            return UIImage(named: "DefaultImage")!
        }
    }
    
    private var generalInformation: some View {
        VStack (alignment: .leading) {
            Text("GENERAL INFO")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            VStack(alignment: .leading) {
                HStack {
                    Text(place.addressLine1!)
                        .font(.title)
                    Spacer()
                    ContentActionButton(content: {
                        Image(systemName: place.isFavourite ? "star.fill" : "star")
                            .foregroundColor(place.isFavourite ? Color.yellow : Color.gray)
                    }, action: {
                        place.isFavourite.toggle()
                    })
                }
                Text(place.addressLine2!)
                    .font(.title2)
                    .hidden(place.addressLine2?.isEmpty ?? true, remove: place.addressLine2?.isEmpty ?? true)
            }
            HStack {
                Text(place.city!)
                Spacer()
                Text(place.county!)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
    
    private var tenancyDuration: some View {
        VStack(alignment: .leading) {
            Text("TENANCY DURATION")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            Spacer()
            HStack {
                Text("Start date")
                Spacer()
                Text(place.startDate!, formatter: itemFormatter)
            }
            Spacer()
            HStack {
                Text("End date")
                Spacer()
                Text(place.endDate!, formatter: itemFormatter)
            }
        }
    }
    
    private var descriptionInformation: some View {
        VStack(alignment: .leading) {
            Text("DESCRIPTION")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            if (place.desc!.isEmpty) {
                Text("No description has been set.")
                    .foregroundColor(.secondary)
            } else {
                Text(place.desc!)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.timeZone = TimeZone.current
    return formatter
}()
