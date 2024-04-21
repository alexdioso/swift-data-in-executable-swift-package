// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import SwiftData

import Shared

@main
struct SwiftDataInExecutableSwiftPackageCMD: ParsableCommand {
    @MainActor mutating func run() throws {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle.main.bundleIdentifier not set")
        }
        print("Bundle.main.bundleIdentifier: \(bundleId)")
        
        print("Creating Model Configuration")
        let schema = Schema([
            Item.self,
        ])
        
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directoryURL = appSupportURL.appendingPathComponent(bundleId)
        try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        
        let fileURL = directoryURL.appendingPathComponent("\(bundleId).store")
        let modelConfiguration = ModelConfiguration(schema: schema, url: fileURL)
        print("\(modelConfiguration.url)")

        print("Creating Model Container")
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        let modelContext = modelContainer.mainContext
        
        print("")
        try listItems(from: modelContext)
        
        var exitRequested = false
        while (!exitRequested) {
            print(
"""

Choose an option:
1. List Items
2. New Item
3. Quit
""")
            let option = readLine()
            switch option {
            case "1":
                try listItems(from: modelContext)
            case "2":
                let newItem = Item(timestamp: Date())
                print("Adding new Item \(newItem.timestamp)")
                modelContext.insert(newItem)
                break
            case "3":
                exitRequested = true
                try modelContext.save()
            default:
                print("Unknown option \(option ?? "")")
                continue
            }
        }
        
        print("Exiting")
    }
    
    private func listItems(from modelContext: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<Item>()
        for item in try modelContext.fetch(fetchDescriptor) {
            print("Item at \(item.timestamp)")
        }
    }
}
