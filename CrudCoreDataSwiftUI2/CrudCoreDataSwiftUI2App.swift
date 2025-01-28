//
//  CrudCoreDataSwiftUI2App.swift
//  CrudCoreDataSwiftUI2
//
//  Created by MacMini6 on 28/01/25.
//


import SwiftUI

@main
struct CrudCoreDataSwiftUI2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
