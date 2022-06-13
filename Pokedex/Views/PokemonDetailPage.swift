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
            HStack {
                Text("Ich bin ein")
                    .font(.body)
                    .fontWeight(.bold)
                TextField("Pokemon Name", text: $pokemonName)
                    .frame(maxWidth: 150)
                    .autocorrectionDisabled(true)
            }

            HStack {
                Text("#\(pokemon.id)")
                ForEach(pokemon.types) { type in
                    PokemonTypeIndicator(type: type)
                }
            }

            LazyImage(source: pokemon.image)
                .aspectRatio(contentMode: .fit)
        }
        .padding(EdgeInsets(top: 64.0, leading: 0, bottom: 0, trailing: 0)) // TODO: Safe Area
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(pokemonName == pokemon.name ? pokemon.color : .white) // TODO: Background on DarkMode
    }
}
