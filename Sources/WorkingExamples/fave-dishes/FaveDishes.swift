import SwiftUI
import Foundation

struct Dish: Identifiable {
  let id = UUID()
  let name: String
  var isFavorite = false
  
  static let allDishes = [
    Dish(name: "🍝 Spaghetti Carbonara"),
    Dish(name: "🧀 Eggplant Parmigiana"),
    Dish(name: "🍮 Classic Panna Cotta"),
    Dish(name: "🥗 Caprese Salad")
  ]
}

class UserData: ObservableObject {
  
  static let shared = UserData()
  
  @Published var pinnedId: UUID? = Dish.allDishes[0].id
  @Published var dishes: [Dish] = Dish.allDishes
  
  var pinnedDish: Dish? {
    get {
      guard let pinnedId = pinnedId else {
        return nil
      }
      return dishes.first { $0.id == pinnedId }
    }

    set {
      if
        let newValue = newValue,
        let pinnedId = pinnedId,
        let i = dishes.firstIndex(where: { $0.id == pinnedId })
      {
        dishes[i] = newValue
      }
    }
  }
}

struct FaveDishes: View {

  @ObservedObject var data = UserData.shared

  var body: some View {
    VStack {
      if data.pinnedDish != nil {
        DishRow(
          dish: Binding<Dish>($data.pinnedDish)!,
          pinnedId: $data.pinnedId
        )
        Divider()
      }
      DishList(dishes: $data.dishes, pinnedId: $data.pinnedId)
      Spacer()
    }
  }
}

struct DishRow: View {

  @Binding var dish: Dish
  @Binding var pinnedId: UUID?
  
  var body: some View {
    HStack {
      Spacer()
      pinIndicator
      Spacer()
      Text(dish.name)
      Spacer()
      favoriteIndicator
      Spacer()
    }
    .padding()
  }
  
  var pinIndicator: some View {
    VStack {
      if dish.id == pinnedId {
        Text("📌")
      }
      Button(
        dish.id == pinnedId ? "Unpin" : "Pin",
        action: togglePin
      )
      .font(.caption)
    }
  }

  var favoriteIndicator: some View {
    Button("\(dish.isFavorite ? "💗" : "🤍")") {
      self.dish.isFavorite.toggle()
    }
  }
  
  func togglePin() {
    pinnedId = dish.id == pinnedId ? nil : dish.id
  }
}

struct DishList: View {

  @Binding var dishes: [Dish]
  @Binding var pinnedId: UUID?
  
  var body: some View {
    VStack {
      ForEach(dishes.indices) { i in
        if self.dishes[i].id != self.pinnedId {
          DishRow(dish: self.$dishes[i], pinnedId: self.$pinnedId)
        }
      }
    }
  }
}

struct FaveDishes_Previews: PreviewProvider {
  static var previews: some View {
    FaveDishes()
  }
}
