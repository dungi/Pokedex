//
//  PokemonDetailPage.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import NukeUI
import SwiftUI

struct PokemonDetailPage: View {
    @State private var pokemonName: String = ""

    private let pokemon: Pokemon

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("Ich bin ein")
                        .font(.body)
                        .fontWeight(.bold)
                    TextField("Pokemon Name", text: $pokemonName)
                        .frame(maxWidth: 150)
                }
            }

            LazyImage(source: pokemon.image)
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(pokemonName == pokemon.name ? pokemon.color : .white)
    }
}
