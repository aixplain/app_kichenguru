//
//  IngredientListView.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import SwiftUI

struct IngredientListView: View {
    @EnvironmentObject var kitchenManager:KitchenManager
    @State var ingredients: [Ingredient] = []
    @State private var isDisplayingAddIngredientSheet:Bool = false

    var body: some View {
        NavigationView{
            ingredientList
        }
        .overlay(alignment: .bottom, content: {
            viewOverlay
        })
        .sheet(isPresented: $isDisplayingAddIngredientSheet){
           AddIngredientSheetView(ingredientList: $ingredients)
                .presentationDetents([.fraction(0.45)])
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    
    var viewOverlay:some View{
        VStack{
            addItemButton
            makeRecipeButton
            
        }
        .padding()
        
        
    }
    

}

//MARK: List
fileprivate extension IngredientListView{
    var ingredientList:some View {
        List {
            ForEach(ingredients) { ingredient in
                buildListItem(from: ingredient)
            }
             .onDelete(perform: deleteItems)
        }
        .navigationTitle("Ingredients")
        .toolbar{
            EditButton()

        }
    }
    
    private func buildListItem(from ingredient: Ingredient) -> some View {
        HStack {
            Text(ingredient.name)
                .font(.callout)
            Spacer()
            if let unitDescription = ingredient.formattedUnitDescription {
                Text(unitDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                ingredients.remove(at:index)
            }
        }
    }
}


//MARK: Adding Ingredients
extension IngredientListView{
    
    private var addItemButton:some View {
        HStack{
            Button(action: {isDisplayingAddIngredientSheet.toggle()}) {
                Label("Add Item", systemImage: "plus.circle.fill")
                    .font(.system(.title3, design: .rounded))
                    .bold()
            }
            Spacer()
        }
    }
}


//MARK: Make recipe
extension IngredientListView{
    
    private var makeRecipeButton:some View {
        Button(action: {
            Task{ @MainActor in
                do{
                    try await kitchenManager.makeRecipe(using: ingredients)
                }catch{
                    kitchenManager.appState = .addingIngredients
                    print(error.localizedDescription)
                }
            }
        }, label: {
            HStack{
                Spacer()
                Label("Make Recipe", systemImage: "sparkles")
                    .font(.title2)
                    .bold()
                Spacer()
            }
        })
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(ingredients.isEmpty)
        .padding()
    }
}

#Preview {
    IngredientListView(ingredients: mockedIngredients)
        .environmentObject(KitchenManager())
}
