//
//  KitchenManager.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import Foundation
import aiXplainKit


final class KitchenManager:ObservableObject {
    @Published var appState:AppState = .addingIngredients
    
    var llama3:Model? = nil
    var stableDiffusion:Model? = nil

    init(){
        setupAiXplain()
    }
    
    private func setupAiXplain(){
        Task{
            configureAPIKey()
            await fetchModels()
        }
    }
    
    
    @MainActor
    func makeRecipe(using ingredientList: [Ingredient]) async throws{
        self.appState = .processing
        
        guard let recipe = try await createRecipe(using: ingredientList) else {
            self.appState = .addingIngredients
            return
        }
        
        self.appState = .showingRecipe(recipe: recipe)
    }
    
    
}
