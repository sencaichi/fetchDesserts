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
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
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

struct DetailView: View {
    let idMeal: String
    @State private var details = [MealDetails]()
    
    var body: some View {
        List(details, id: \.idMeal) { detail in
            VStack {
                AsyncImage(url: URL(string: detail.strMealThumb))
                { image in
                    image.resizable()
                // placeholder until image loads
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                Text(detail.strInstructions!)
                
            }
        }
        .navigationTitle("Details")
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
}


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
    @State private var meals = [Meal]()
    
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
