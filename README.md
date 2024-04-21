# swift-data-in-executable-swift-package
This is an example of using SwiftData in an executable Swift Package. SwiftData uses Bundle.main.bundleIdentifier and when it can't find it, like in an executable Swift Package, it throws this error:
```
SwiftData/DataStoreCoreData.swift:32: Fatal error: Unable to determine Bundle Name
```
The solution is to create an Info.plist with at least a Bundle Identifier and then [link that into the executable](https://forums.swift.org/t/swift-package-manager-use-of-info-plist-use-for-apps/6532/13). This example also [changes the default storage location which is the same for all macOS SwiftData applications](https://gist.github.com/pdarcey/981b99bcc436a64df222cd8e3dd92871#).
