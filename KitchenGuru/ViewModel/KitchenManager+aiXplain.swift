//
//  KitchenManager+aiXplain.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import Foundation
import aiXplainKit


extension KitchenManager{
    func configureAPIKey(){
        AiXplainKit.shared.keyManager.TEAM_API_KEY = "<SUPERSECRET123>"
    }
    

    func fetchModels() async {
        let modelProvider = ModelProvider()
        
        self.llama3 = try? await modelProvider.get("6622cf096eb563537126b1a1")
    }
}



//MARK: Llama 3
extension KitchenManager{
    
    func createRecipe(using ingredientList:[Ingredient]) async throws -> Recipe?{
        guard let llama3 = self.llama3 else {
            return nil
        }
        
        var ingredientsAsString:String = ""
        
        for ingredient in ingredientList {
            ingredientsAsString.append(ingredient.description)
        }
        
        let modelOutput = try await llama3.run(["data":ingredientsAsString,"context":LlamaSystemContext])
        let recipe = try Recipe(modelOutput.output)
        return recipe
        
    }
}




//MARK: Stable Diffusion
extension KitchenManager {
    func createImageFor(_ recipe:Recipe) async->URL?{
        guard let stableDiffusion = self.stableDiffusion else {
            return nil
        }
        
        let prompt:String = "Digital sketch of the \(recipe.title)"
        
        guard let modelOutput = try? await stableDiffusion.run(["text":prompt,"seed":"academy"]) else {
            return nil
        }

        return URL(string: "")
        
    }
    
}

//MARK: System Promt
let LlamaSystemContext:String = """
            You are an AI assistant designed to help users generate recipes based on a list of ingredients they provide. Users will give you a list of ingredients in the following format:
            ingredient qty? unit?
            For example:
            Cheese 100 mg
            Eggs 2
            Meat
            Salt

            Based on this list, generate a recipe. The recipe should always be returne ONLY the following JSON: no more information, just the JSON without any kind of formating

            ```json
            {"title": "Recipe title (Two words)","recipeHistory": "recipe history in 1 paragraph","instructions": ["instruction 0","instruction 1",..."instruction n]}
        """
