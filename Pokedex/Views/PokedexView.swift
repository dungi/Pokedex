//
//  PokedexView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject private var viewModel = PokedexViewModel()

    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.pokemon) { pokemon in
                    NavigationLink(destination: PokemonDetailPage(pokemon: pokemon)) {
                        PokedexCard(pokemon: pokemon)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        }
        .navigationTitle("Pokedex")
        .onAppear {
            Task {
                guard viewModel.pokemon.isEmpty else { return }
                await viewModel.loadPokemons()
                print("Finished loading")
            }
        }
    }
}
