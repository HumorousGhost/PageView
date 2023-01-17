# PageView

Page turning function similar to ScrollView.

## Supported Platforms
* iOS 13.0
* macOS 10.15
* tvOS 13.0
* watchOS 6.0

## Usage
```swift
import PageView

struct ContentView: View {
    let textArray = ["Hello", "world", "Hello world"]
    @State private var index: Int = 0
    
    var body: some View {
        PageView(count: self.textArray.count, currentIndex: $index) {
            ForEach(self.textArray, id: \.self) { text in
                textView(text: text)
            }
        }
    }
    
    @ViewBuilder
    private func textView(text: String) -> some View {
        Text(text)
            .padding()
    }
}
```

## Installation
You can add PageView to an Xcode project by adding it as a package dependency

* From the **File** menu, select **Swift Packages** -> **Add Package Dependency**...
Enter https://github.com/HumorousGhost/PageView into the package repository URL text field.
Link **PageView** to your application target.
