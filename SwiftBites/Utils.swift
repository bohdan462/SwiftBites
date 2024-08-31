import SwiftUI

extension View {
  func alert(error: Binding<Error?>) -> some View {
    self.alert(isPresented: Binding<Bool>(
      get: { error.wrappedValue != nil },
      set: { if !$0 { error.wrappedValue = nil } }
    )) {
      Alert(
        title: Text("Oops!"),
        message: Text(error.wrappedValue?.localizedDescription ?? "An unknown error occurred."),
        dismissButton: .default(Text("Dismiss"))
      )
    }
  }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
