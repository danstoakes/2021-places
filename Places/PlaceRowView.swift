//
//  PlaceRowView.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI

struct PlaceRowView: View {
    @ObservedObject var place : Place
    
    var body: some View {
        HStack
        {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack (alignment: .leading) {
                Text(place.addressLine1 ?? "")
                    .font(.callout)
                Text(place.addressLine2 ?? "")
                    .font(.caption)
                    .hidden(place.addressLine2?.isEmpty ?? true, remove: place.addressLine2?.isEmpty ?? true)
            }
            
            Spacer()
            
            if place.isFavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
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
}

/* struct PlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRowView()
    }
} */
