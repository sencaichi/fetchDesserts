//
//  ContentView.swift
//  fetchDesserts
//
//  Created by Sen Cai on 6/16/23.
//

import SwiftUI


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
    // assign an instance of Meal to state
    @State var meals = [Meal]()
    
    var body: some View {
        NavigationView {
            // write a function (below) that will fetch data from the endpoint and then iterate through the response
            List(meals, id: \.idMeal) { meal in
                VStack(alignment: .leading) {
                    // link to the detailed view
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
