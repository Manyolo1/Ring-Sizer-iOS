//
//  new_ring_sizerApp.swift
//  new_ring_sizer
//
//  Created by MANYA on 11/09/24.
//

import SwiftUI

@main
struct new_ring_sizerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
