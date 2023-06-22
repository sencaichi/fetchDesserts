//
//  ContentView.swift
//  fetchDesserts
//
//  Created by Sen Cai on 6/16/23.
//

import SwiftUI

// model the data to be decoded
// nested json data addressed on line 44
// considering using classes for objective-c interoperability
struct Meal: Codable, Hashable {
        let strMeal: String
        let strMealThumb: String
        let idMeal: String
    }

struct MealDetails: Codable, Hashable {
    let idMeal: String
    var strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String?
    let strArea: String?
    var strInstructions: String?
    var strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
}

extension String {
    
    public var isNotEmpty: Bool {
        
        return !self.isEmpty
    }
}

//extension MutableCollection {
//
//    /// Returns the element at the specified index iff it is within count, otherwise nil.
//    subscript (safe index: Index) -> Element? {
//        get {
//            indices.contains(index) ? self[index] : nil
//        }
//        mutating set {
//            if indices.contains(index), let value = newValue {
//                self[index] = value
//            }
//        }
//    }
//}

struct DetailView: View {
    let idMeal: String
    @State var details = [MealDetails]()
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                ForEach(details, id: \.idMeal) { detail in
                    Text(detail.strMeal)
                    AsyncImage(url: URL(string: detail.strMealThumb))
                    { image in
                        image.resizable()
                        // placeholder until image loads
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 150, height: 150)
                    Text(detail.strInstructions!)
                    ForEach(1...20, id: \.self) {
                        index in
                        let ingredientKey = "strIngredient\(index)"
                        let ingredientValue = value(for: ingredientKey, in: detail) // Access property dynamically
                        
                        // Match and concatenate values
                        let measureKey = "strMeasure\(index)"
                        let measureValue = value(for: measureKey, in: detail) // Access property dynamically
                        
                        let combinedValue = measureValue + ingredientValue
                        
                        Text(combinedValue)
                    }
                }
            }
        }
            .task {
                await fetchDetails(id: idMeal)
            }
        }
        
        func fetchDetails(id: String) async {
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=" + id)
            else {
                print("This URL does not work.")
                return
            }
            print(url)
            do {
                let (detailData, _) = try await URLSession.shared.data(from: url)
                // decode json data
                let decodedResp = try JSONDecoder().decode([String: [MealDetails]].self, from: detailData)
                // decodedResponse["meals"] because of nested JSON object
                details = decodedResp["meals"] ?? []
                
            } catch {
                print("Issue with data.")
            }
        }
    
    func value(for key: String, in object: Any) -> String {
            let mirror = Mirror(reflecting: object)
            
            for child in mirror.children {
                if let label = child.label, label == key {
                    print(child.value)
                    if let value = child.value as? String {
                        return value
                    }
                }
            }
            
            return ""
        }
    }


//struct Ingredients: View {
//    var detail:
//
//    var body: some View {
//        List {
//            ForEach(1...9, id: \.self) {i in
//                print(detail["strIngredient\(i)"]?)
//            }
//        }
//    }
//}


// for different iOS versions
//struct MyNavigation<Content>: View where Content: View {
//    @ViewBuilder var content: () -> Content
//
//    var body: some View {
//        if #available(iOS 16, *) {
//            NavigationStack(root: content)
//        } else {
//            NavigationView(content: content)
//        }
//    }
//}

struct ContentView: View {
    @State var meals = [Meal]()
    
    var body: some View {
        NavigationView {
            List(meals, id: \.idMeal) { meal in
                VStack(alignment: .leading) {
                    NavigationLink(destination: DetailView(idMeal: meal.idMeal)) {
                        AsyncImage(url: URL(string: meal.strMealThumb))
                        { image in
                            image.resizable()
                        // placeholder until image loads
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)
                        Text(meal.strMeal)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Desserts")
            .task {
                await fetchData()
            }
        }
    }
        
        // fetch data from endpoint
        func fetchData() async {
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
                print("This URL does not work.")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                // decode json data
                let decodedResponse = try JSONDecoder().decode([String: [Meal]].self, from: data)
                // decodedResponse["meals"] because of nested JSON object
                meals = decodedResponse["meals"] ?? []
            } catch {
                print("Issue with data.")
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
