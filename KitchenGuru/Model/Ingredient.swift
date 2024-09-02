//
//  Ingredient.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import Foundation


struct Ingredient: Identifiable, CustomStringConvertible {
    let name: String
    let quantity: Double?
    var unit: KitchenUnit?

    var id: String {
        name
    }

    var description: String {
        guard let quantity = quantity, let unit = unit else {
            return name
        }
        return "\(name) (\(quantity) \(unit.rawValue))"
    }
    
    var formattedUnitDescription:String?{
        guard let quantity = quantity, let unit = unit else {
            return nil
        }
        return "\(quantity) \(unit.rawValue)"
    }
    

    enum KitchenUnit: String, Identifiable, CaseIterable {
        case ml
        case mg

        var id: String {
            rawValue
        }
    }
}

//MARK: Mock

let mockedIngredients: [Ingredient] = [
    Ingredient(name: "Water", quantity: 500, unit: .ml),
    Ingredient(name: "Salt", quantity: 5, unit: .mg),
    Ingredient(name: "Sugar", quantity: 10, unit: .mg),
    Ingredient(name: "Olive Oil", quantity: 50, unit: .ml),
    Ingredient(name: "Lemon Juice", quantity: 20, unit: .ml),
    Ingredient(name: "Garlic", quantity: 2, unit: .mg),
    Ingredient(name: "Pepper", quantity: 1, unit: .mg),
    Ingredient(name: "Basil", quantity: nil, unit: nil),
    Ingredient(name: "Thyme", quantity: nil, unit: nil),
    Ingredient(name: "Rosemary", quantity: nil, unit: nil)
]


