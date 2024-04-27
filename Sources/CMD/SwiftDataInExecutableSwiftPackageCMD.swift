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
        let modelContext = ModelContainer.sharedModelContainer.mainContext
        
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
