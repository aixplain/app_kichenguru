//
//  ContentView.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var kitchenManager:KitchenManager = KitchenManager()
    
    var body: some View {
        ZStack{
            switch kitchenManager.appState {
            case .addingIngredients:
                IngredientListView()
            case .processing:
                ProgressView("Generating Recipe")
            case .showingRecipe(let recipe):
                RecipeView(recipe: recipe)
            }
        }.environmentObject(kitchenManager)
    }
}

#Preview {
    ContentView()
}
