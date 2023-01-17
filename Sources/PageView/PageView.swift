
import SwiftUI
import ChangeObserver

public struct PageView<Content>: View where Content: View {
    
    let count: Int
    @State private var ignore: Bool = false
    @State private var currentFloatIndex: CGFloat = 0 {
        didSet {
            ignore = true
            currentIndex = min(max(Int(currentFloatIndex.rounded()), 0), self.count)
            ignore = false
        }
    }
    
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    /// initialization method
    /// - Parameters:
    ///   - count: total number of pages
    ///   - currentIndex: The number of pages currently displayed
    ///   - content: some View
    public init(count: Int, currentIndex: Binding<Int>, content: () -> Content) {
        self.count = count
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @Binding var currentIndex: Int {
        didSet {
            if !ignore {
                currentFloatIndex = CGFloat(currentIndex)
            }
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content
                    .frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(dragGesture(geometry.size.width))
            .onDataChange(of: currentIndex) { value in
                withAnimation(.easeOut) {
                    currentFloatIndex = CGFloat(value)
                }
            }
            .onDataChange(of: self.translation) { newValue in
                debugPrint(newValue)
            }
        }
    }
    
    private func dragGesture(_ width: CGFloat) -> some Gesture {
        DragGesture()
            .updating(self.$translation) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let offset = value.translation.width / width
                let offsetPredicted = value.predictedEndTranslation.width / width
                let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                self.currentIndex = min(max(Int(newIndex), 0), self.count - 1)
                
                withAnimation(.easeOut) {
                    if offsetPredicted < -0.5 && offset > -0.5 {
                        self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() + 1), 0), self.count - 1))
                    } else if offsetPredicted > 0.5 && offset < 0.5  {
                        self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded() - 1), 0), self.count - 1))
                    } else {
                        self.currentFloatIndex = CGFloat(min(max(Int(newIndex.rounded()), 0), self.count - 1))
                    }
                }
            }
    }
}
