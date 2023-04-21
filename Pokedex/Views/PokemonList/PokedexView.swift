//
//  PokedexView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import SwiftUI

struct PokedexView: View {
    @ObservedObject private var viewModel = PokedexViewModel()
    @State private var isShowingCard = false
    @State private var currentPokemon: Pokemon?
    @State private var searchString = ""

    @Namespace var animation

    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                if let pokemons = viewModel.pokemons {
                    ForEach(pokemons.filter {
                        $0.name.lowercased().contains(searchString.isEmpty ? $0.name.lowercased() : searchString.lowercased())
                    }) { pokemon in
                        PokedexCard(pokemon: pokemon)
                            .matchedGeometryEffect(id: pokemon.id, in: animation)
                            .onTapGesture {
                                currentPokemon = pokemon
                                isShowingCard = true
                            }
                    }
                }
            }
            .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .automatic))
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
        }
        .overlay {
            if let currentPokemon, isShowingCard {
                PokemonDetailPage(isShowingDetail: $isShowingCard, pokemon: currentPokemon, animation: animation)
            }
        }
        .navigationTitle("Pokédex")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Random") {
                    currentPokemon = viewModel.pokemons?.randomElement()
                    isShowingCard = true
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
        .animation(.default, value: isShowingCard)
    }
}
