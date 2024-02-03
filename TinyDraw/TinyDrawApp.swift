//
//  TinyDrawApp.swift
//  TinyDraw
//
//  Created by Игорь Михайлов on 01.12.2023.
//

import SwiftUI

@main
struct TinyDrawApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Drawing.init) { file in
            ContentView()
        }
    }
}
