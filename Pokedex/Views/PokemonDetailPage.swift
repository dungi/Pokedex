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

    private let gridItems: [GridItem] = Array(repeating: .init(.fixed(120.0)), count: 1)

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(pokemon.name)
                        .font(.largeTitle)
                    Spacer()
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.subheadline).italic()
                }
                HStack(alignment: .top) {
                    if let text = pokemon.infoText {
                        Text(text)
                            .font(.caption)
                    }
                    Spacer()
                    ForEach(pokemon.types) { type in
                        PokemonTypeIndicator(type: type)
                            .frame(height: 40)
                    }
                }


                LazyVStack(alignment: .leading) {
                    PokeDetailInfo(title: "Allgemeine Informationen", dictionary: [
                        "Gewicht": "\(Double(pokemon.weight)/10.0) kg",
                        "Kategorie": pokemon.genum,
                        "Geschlecht": pokemon.genderDescription
                    ])

                    PokeDetailInfo(title: "Sprache", dictionary: pokemon.languagesDictionary)
                }

                GroupBox("Stats") {
                    PokemonStats(stats: pokemon.stats)
                }

                if let sprites = pokemon.sprites?.sprites {
                    GroupBox("Sprites") {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: gridItems) {
                                ForEach(sprites.sorted(by: <), id: \.key) { value in
                                    PokemonSprite(image: value.value, subtitle: value.key)
                                }
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 64.0, leading: 16, bottom: 16.0, trailing: 16)) // TODO: Safe Area
            .background(pokemon.color)
        }

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

struct PokeDetailInfo: View {
    @State var title: String
    @State var dictionary: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(title)
                .font(.headline)

            VStack(spacing: 0) {
                ForEach(dictionary.sorted(by: <), id: \.key) { value in
                    HStack {
                        Text(value.key)
                            .font(.caption)
                            .fontWeight(.bold)
                        Spacer()
                        Text(value.value)
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                    Divider()
                }
            }
            .background(Color("backgroundColor"))
            .cornerRadius(8.0)

        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 8.0, trailing: 0))
    }
}

struct PokemonSprite: View {
    var image: String
    var subtitle: String

    var body: some View {
        ZStack(alignment: .bottom) {
            LazyImage(source: image)
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 120.0)
            Text(subtitle)
                .font(.subheadline)
        }
    }
}
