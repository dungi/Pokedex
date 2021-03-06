//
//  PokedexView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject private var viewModel = PokedexViewModel()
    @State private var currentPokemon: Pokemon?
    @State private var searchString = ""

    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                if let pokemons = viewModel.pokemons {
                    ForEach(pokemons.filter {
                        $0.name.lowercased().contains(searchString.isEmpty ? $0.name.lowercased() : searchString.lowercased())
                    }) { pokemon in
                        PokedexCard(pokemon: pokemon)
                            .onTapGesture {
                                currentPokemon = pokemon
                            }
                    }
                }
            }
            .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .automatic))
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
        }
        .sheet(item: $currentPokemon) { pokemon in
            PokemonDetailPage(pokemon: pokemon)
                .presentationDetents([
                    .large
                ])
        }
        .navigationTitle("Pokédex")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Random") {
                    currentPokemon = viewModel.pokemons?.randomElement()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadPokemons()
            }
        }
        .navigationTitle("Pokedex")
        .navigationBarTitleDisplayMode(.large)
    }
}
