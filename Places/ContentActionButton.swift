//
//  FavouriteButton.swift
//  Places
//
//  Created by Dan Stoakes on 06/08/2021.
//

import SwiftUI

struct ContentActionButton<Content: View>: View {
    let content: () -> Content
    let action: () -> Void
    
    init (@ViewBuilder content: @escaping () -> Content, action: @escaping () -> Void) {
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) { content() }
    }
}
