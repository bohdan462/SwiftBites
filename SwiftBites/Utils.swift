import SwiftUI

extension View {
  func alert(error: Binding<Error?>) -> some View {
    self.alert(isPresented: Binding<Bool>(
      get: { error.wrappedValue != nil },
      set: { if !$0 { error.wrappedValue = nil } }
    )) {
      Alert(
        title: Text("Error"),
        message: Text(error.wrappedValue?.localizedDescription ?? "An unknown error occurred."),
        dismissButton: .default(Text("Dismiss"))
      )
    }
  }
}

  enum StorageError: LocalizedError {
    case ingredientExists
    case categoryExists
    case recipeExists

    var errorDescription: String? {
      switch self {
      case .ingredientExists:
        return "Ingredient with the same name exists"
      case .categoryExists:
        return "Category with the same name exists"
      case .recipeExists:
        return "Recipe with the same name exists"
      }
    }
  }
