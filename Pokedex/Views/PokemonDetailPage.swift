//
//  PokemonDetailPage.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import Charts
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
                        .frame(height: 40)
                }
            }

            PokemonStats(stats: pokemon.stats)

            LazyImage(source: pokemon.image)
                .aspectRatio(contentMode: .fit)
        }
        .padding(EdgeInsets(top: 64.0, leading: 0, bottom: 0, trailing: 0)) // TODO: Safe Area
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(pokemonName == pokemon.name ? pokemon.color : .white) // TODO: Background on DarkMode
    }
}

struct PokemonStats: View {
    var stats: [PokemonStat]

    var body: some View {
        Chart(stats, id: \.category) { value in
            BarMark(
                x: .value("Wert", value.baseValue),
                y: .value("Werte", value.category)
            ).foregroundStyle(.yellow)
        }.chartXScale(domain: 0 ... 120)
    }
}
