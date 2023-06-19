//
//  ContentView.swift
//  fetchDesserts
//
//  Created by Sen Cai on 6/16/23.
//

import SwiftUI

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
                Text(meal.strMeal)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            }
            .navigationTitle("Desserts")
            .task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("This URL does not work.")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([String: [Meal]].self, from: data)
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
