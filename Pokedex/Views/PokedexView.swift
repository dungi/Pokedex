//
//  PokedexView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject private var viewModel = PokedexViewModel()
    @State private var currentPokemon: PokemonModel?
    @State private var searchString = ""

    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(searchString == "" ? viewModel.pokemon : viewModel.pokemon.filter {
                    $0.name.lowercased().contains(searchString.lowercased())
                }) { pokemon in
                    PokedexCard(pokemon: pokemon)
                        .onTapGesture {
                            currentPokemon = pokemon
                        }
                }
            }
            .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .automatic))
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        }
        .sheet(item: $currentPokemon) { pokemon in
            PokemonDetailPage(pokemon: pokemon)
                .presentationDetents([
                    .medium, .large
                ])
        }
        .navigationTitle("Pokédex")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Random") {
                    currentPokemon = viewModel.pokemon.randomElement()
                }
            }
        }
        .onAppear {
            Task {
                guard viewModel.pokemon.isEmpty else { return }
                await viewModel.loadPokemons()
            }
        }
    }
}
