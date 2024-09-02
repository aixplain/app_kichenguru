//
//  RecipeView.swift
//  KitchenGuru
//
//  Created by Joao Maia on 18/06/24.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject var kitchenManager:KitchenManager
    @State var imageURL:URL?
    let recipe: Recipe
    
    var body: some View {
        NavigationView{
            VStack{
                instructionsView
            }
            .navigationTitle(recipe.title)
            .toolbar{
                doneButton
            }
            
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear{
            Task{@MainActor in await loadImages()}
        }
    }
    
    
    private var doneButton:some View {
        Button(action: {
            kitchenManager.appState = .addingIngredients
            
        }, label: {
            Text("Done")
        })
    }
    
}

// MARK: - Header
extension RecipeView {
    private var headerView: some View {
        VStack {
            HStack {
                Text(recipe.title)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
        }
        .padding()
        .padding(.bottom,-20)
    }
}

// MARK: - Instructions
extension RecipeView {
    private var instructionsView: some View {
        List{
            ForEach(recipe.instructions.indices, id: \.self) { index in
                Text("\(recipe.instructions[index])")
            }
            
            recipePhoto
        }
    }
}


//MARK: Images
extension RecipeView{
    
    func loadImages() async{
        self.imageURL = await kitchenManager.createImageFor(recipe)
    }
    
    @ViewBuilder
    var recipePhoto:some View {
        
        if let recipeUrl = imageURL{
            AsyncImage(url: recipeUrl,content: {
                if let img = $0.image {
                    img
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            })
            .scaledToFit()
        }
        
    }
}

#Preview {
    RecipeView(recipe: beefWellingtonRecipe)
}
