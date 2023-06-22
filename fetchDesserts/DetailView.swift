//
//  DetailView.swift
//  fetchDesserts
//
//  Created by Sen Ayané on 6/22/23.
//

import SwiftUI

struct DetailView: View {
    let idMeal: String
    @State var details = [MealDetails]()
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                // iterate through details and display values
                ForEach(details, id: \.idMeal) { detail in
                    Text(detail.strMeal)
                        .font(.title)
                    AsyncImage(url: URL(string: detail.strMealThumb))
                    { image in
                        image.resizable()
                        // placeholder until image loads
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    Text("Instructions")
                        .font(.headline)
                        .padding(2)
                    Text(detail.strInstructions!)
                        .padding(2)
                    Text("Ingredients")
                        .font(.headline)
                        .padding(2)
                    // loop through the object twenty times, concating the measure values to the ingredient values
                    ForEach(1...20, id: \.self) {
                        index in
                        let ingredientKey = "strIngredient\(index)"
                        let ingredientValue = value(for: ingredientKey, in: detail) // access property dynamically
                        
                        // match and concatenate values
                        let measureKey = "strMeasure\(index)"
                        let measureValue = value(for: measureKey, in: detail)
                        
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
                // this conditional should filter out any nil or empty values
                if let label = child.label, label == key {
                    if let value = child.value as? String {
                        return value + " "
                    }
                }
            }
            
            return ""
        }
    }
