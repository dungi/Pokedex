//
//  PokemonDetailPage.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import NukeUI
import RealmSwift
import SwiftUI

struct PokemonDetailPage: View {
    @State var pokemon: Pokemon

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16.0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("#\(String(format: "%03d", pokemon.id))")
                            .font(.subheadline).italic()
                        Text(pokemon.name)
                            .font(.largeTitle)
                    }
                    Spacer()
                    LazyImage(source: pokemon.sprites?.frontDefault)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 64)
                }
                HStack(alignment: .top) {
                    if let text = pokemon.infoText {
                        VStack {
                            Text(text)
                                .font(.caption)
                            if let formText = pokemon.formText {
                                Text(formText)
                                    .font(.caption)
                            }
                        }
                    }
                    Spacer()
                    ForEach(pokemon.types) { type in
                        PokemonTypeIndicator(type: type)
                            .frame(height: 32)
                    }
                }

                GroupBox("Typ-Schwächen") {
                    ScrollView(.horizontal) {
                        HStack {
                            WeaknessView(types: pokemon.types, tintColor: pokemon.color)
                            Spacer()
                        }
                    }
                }

                PokemonInfoView(pokemon: pokemon)

                GroupBox("Basiswerte") {
                    PokemonStatsView(stats: pokemon.stats, foregroundStyle: pokemon.color)
                }

                if let sprites = pokemon.sprites {
                    PokemonSpriteGrid(sprites: sprites)
                }
            }
            .padding(EdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)) // TODO: Safe Area
        }
    }
}

