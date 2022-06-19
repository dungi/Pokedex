//
//  PokemonDetailPage.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import Charts
import NukeUI
import RealmSwift
import SwiftUI

struct PokemonDetailPage: View {
    private let pokemon: Pokemon

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(pokemon.name)
                    .font(.largeTitle)
                Spacer()
                Text("#\(String(format: "%03d", pokemon.id))")
                    .font(.subheadline).italic()
            }
            HStack {
                Spacer()
                ForEach(pokemon.types) { type in
                    PokemonTypeIndicator(type: type)
                        .frame(height: 40)
                }
            }

            GroupBox("Stats") {
                PokemonStats(stats: pokemon.stats)
            }

            LazyImage(source: pokemon.sprites?.frontDefault)
                .aspectRatio(contentMode: .fit)
        }
        .padding(EdgeInsets(top: 64.0, leading: 16, bottom: 0, trailing: 16)) // TODO: Safe Area
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(pokemon.color)
    }
}

struct PokemonStats: View {
    var stats: MutableSet<PokemonStat>

    var body: some View {
        Chart(stats, id: \.category) { value in
            BarMark(
                x: .value("Wert", value.baseValue),
                y: .value("Werte", value.category)
            ).foregroundStyle(.yellow)
        }
    }
}
