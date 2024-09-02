//
//  AddIngredientSheetView.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import SwiftUI

struct AddIngredientSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var ingredientList: [Ingredient]
    
    @State private var ingredientName: String = ""
    @State private var ingredientQto: Double? = nil
    @State private var ingredientKitchenUnit: Ingredient.KitchenUnit = .mg
    
    var body: some View {
        NavigationView {
            Form {
                ingredientNameField
                quantitySection
            }
            .animation(.default,value: ingredientQto)
            .navigationTitle("New Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .bottom, content: {
                viewOverlay
            })
        }
    }
    
    
    private var viewOverlay:some View{
        Button(action: {
            addItem()
        }, label: {
            HStack{
                Spacer()
                Text("Add Ingredient").disabled(!ingredientName.isEmpty)
                Spacer()
            }
        })
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding()
        .disabled(ingredientName.isEmpty)
    }
    
    private var ingredientNameField: some View {
        TextField("Name", text: $ingredientName)
    }
    
    private var quantitySection: some View {
        Section(header: Text("Quantity")) {
            TextField("Quantity (Optional)", value: $ingredientQto, format: .number)
                .keyboardType(.decimalPad)
            
            if ingredientQto  != nil{
                unitPicker
            }
        }
    }
    
    private var unitPicker: some View {
        Picker("Unit", selection: $ingredientKitchenUnit) {
            ForEach(Ingredient.KitchenUnit.allCases, id: \.self) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
    }
    
    
    private func addItem(){
        ingredientList.append(Ingredient(name: ingredientName,
                                         quantity: ingredientQto,
                                         unit: ingredientKitchenUnit))
        dismiss()
    }
}

#Preview {
    AddIngredientSheetView(ingredientList: .constant(mockedIngredients))
}
