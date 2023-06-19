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
struct Meal: Codable {
        let strMeal: String
        let strMealThumb: String
        let idMeal: String
    }

struct ContentView: View {
    @State private var meals = [Meal]()
    
    var body: some View {
        NavigationView {
            List(meals, id: \.idMeal) { meal in VStack(alignment: .leading) {
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
