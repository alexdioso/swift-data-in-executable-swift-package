import Foundation
import SwiftData

extension ModelContainer {
  public static let sharedModelContainer: ModelContainer = {
    guard let bundleId = Bundle.main.bundleIdentifier else {
      fatalError("Bundle.main.bundleIdentifier not set")
    }
    print("Bundle.main.bundleIdentifier: \(bundleId)")

    print("Creating Model Configuration")
    let schema = Schema([
      Item.self
    ])

    let fileManager = FileManager.default
    let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
      .first!
    let directoryURL = appSupportURL.appendingPathComponent(bundleId)
    do {
      try fileManager.createDirectory(
        at: directoryURL, withIntermediateDirectories: true, attributes: nil)

      let fileURL = directoryURL.appendingPathComponent("\(bundleId).store")
      let modelConfiguration = ModelConfiguration(schema: schema, url: fileURL)
      print("\(modelConfiguration.url)")

      print("Creating Model Container")
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }()
}
