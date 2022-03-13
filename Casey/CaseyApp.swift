//
//  CaseyApp.swift
//  Casey
//
//  Created by Stuart Wallace on 3/9/22.
//

import SwiftUI

@main
struct CaseyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
