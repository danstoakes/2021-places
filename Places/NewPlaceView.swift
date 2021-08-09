//
//  NewPlaceView.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI
import CoreData

struct NewPlaceView: View {
    typealias CompletionHandler = (Data, String, String, String, String, String, Date, Date, Bool, String, Double, Double) -> Void
    
    @Binding var showingAddModal: Bool
    
    @State var showingImagePickerModal: Bool = false
    @State var showingAddressLine2Option: Bool = false
    @State var showingLoadingView: Bool = false
    
    @State var inputImage: UIImage? = UIImage(named: "DefaultImage")
    
    @State var addressLine1: String
    @State var addressLine2: String
    @State var city: String
    @State var county: String
    @State var postalCode: String
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var isFavourite: Bool
    @State var description: String
    @State var latitude: Double
    @State var longitude: Double
    @State var address = Address()
    
    let action: (Data, String, String, String, String, String, Date, Date, Bool, String, Double, Double) -> Void
    
    init(showingAddModal : Binding<Bool>, completion: @escaping CompletionHandler) {
        self._showingAddModal = showingAddModal
        self._addressLine1 = State(initialValue: "")
        self._addressLine2 = State(initialValue: "")
        self._city = State(initialValue: "")
        self._county = State(initialValue: "")
        self._postalCode = State(initialValue: "")
        self._startDate = State(initialValue: Date())
        self._endDate = State(initialValue: Date())
        self._isFavourite = State(initialValue: false)
        self._description = State(initialValue: "")
        self._latitude = State(initialValue: 10.0)
        self._longitude = State(initialValue: 10.0)
        self.action = completion
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                CircleImage(image: Image(uiImage: inputImage!))
                    .padding(.top, 40)
                Button("Choose") { showingImagePickerModal.toggle() }
                
                VStack {
                    generalInformation
                    Divider()
                    tenancyDuration
                    Divider()
                    descriptionInformation
                    Divider()
                    additionalInformation
                }
                .padding()
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingLoadingView.toggle()
                            CLGeocoder().geocodeAddressString(address.getAddressString(), completionHandler: {(placemarks, error) -> Void in
                                if((error) != nil){
                                    print("Error", error ?? "")
                                }
                                if let placemark = placemarks?.first {
                                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                    latitude = coordinates.latitude
                                    longitude = coordinates.longitude
                                    
                                    self.action((inputImage?.jpegData(compressionQuality: 1.0))!, addressLine1, addressLine2, city, county, postalCode, startDate, endDate, isFavourite, description, latitude, longitude)
                                }
                            })
                        }, label: {
                            if !showingLoadingView {
                                Text("Add")
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        })
                    }
                })
            }
            .navigationBarTitle("New Place", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                showingAddModal.toggle()
            })
            .sheet(isPresented: $showingImagePickerModal) {
                ImagePicker(image: self.$inputImage)
            }
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
                    TextField("Address Line 1", text: $addressLine1)
                        .font(.title)
                        .autocapitalization(.words)
                        .onChange(of: addressLine1) {
                            address.addressLine1 = $0
                        }
                    ContentActionButton(content: {
                        Image(systemName: isFavourite ? "star.fill" : "star")
                            .foregroundColor(isFavourite ? Color.yellow : Color.gray)
                    }, action: {
                        isFavourite.toggle()
                    })
                }
                /// !!! -- IMPLEMENT AS CUSTOM VIEW TYPE, I.E. SWITCHVIEW -- !!!
                TextField("Address Line 2", text: $addressLine2)
                    .font(.title2)
                    .autocapitalization(.words)
                    .hidden(!showingAddressLine2Option, remove: true)
                    .onChange(of: addressLine2) {
                        address.addressLine2 = $0
                    }
                
                ContentActionButton(content: {
                    if (!showingAddressLine2Option) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Address Line 2")
                    }
                }, action: {
                    showingAddressLine2Option.toggle()
                })
                /// !!! -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -- !!!
            }
            HStack {
                TextField("City", text: $city)
                    .autocapitalization(.words)
                    .onChange(of: city) {
                        address.city = $0
                    }
                Spacer()
                TextField("County", text: $county)
                    .autocapitalization(.words)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: county) {
                        address.county = $0
                    }
            }
            .font(.subheadline)
        }
    }
    
    private var tenancyDuration: some View {
        VStack(alignment: .leading) {
            Text("TENANCY DURATION")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            VStack
            {
                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    displayedComponents: [.date]
                )
            }
        }
    }
    
    private var descriptionInformation: some View {
        VStack(alignment: .leading) {
            Text("DESCRIPTION")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            TextField("Description", text: $description)
        }
    }
    
    private var additionalInformation: some View {
        VStack(alignment: .leading) {
            Text("ADDITIONAL INFO")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
            VStack (spacing: 10)
            {
                TextField("Postcode", text: $postalCode)
                    .autocapitalization(.allCharacters)
                    .onChange(of: postalCode) {
                        address.postalCode = $0
                    }
            }
        }
    }
}

extension View {
    @ViewBuilder func hidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
