//
//  AppState.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import Foundation
enum AppState {
    case addingIngredients
    case processing
    case showingRecipe(recipe:Recipe)
}
