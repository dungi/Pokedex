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
                            .frame(height: 40)
                    }
                }

                GroupBox("Typ-Schwächen") {
                    WeaknessView(types: pokemon.types)
                }


                LazyVStack(alignment: .leading) {
                    PokeDetailInfo(title: "Allgemeine Informationen", dictionary: [
                        "Generation": pokemon.generation?.localizedName,
                        "Spiel": pokemon.generation?.gameName,
                        "Region": pokemon.generation?.regionName,
                        "Gewicht": "\(Double(pokemon.weight)/10.0) kg",
                        "Kategorie": pokemon.genum,
                        "Fangrate": "\(pokemon.captureRate)",
                        "Ei-Zyklen": "\(pokemon.hatchCounter)",
                        "Geschlecht": pokemon.genderDescription
                    ].compactMapValues { $0 })

                    PokeDetailInfo(title: "Auf anderen Sprachen", dictionary: pokemon.languagesDictionary)
                }

                GroupBox("Basiswerte") {
                    PokemonStats(stats: pokemon.stats)
                }

                if let sprites = pokemon.sprites {
                    PokemonSpriteGrid(sprites: sprites)
                }
            }
            .padding(EdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)) // TODO: Safe Area
        }
        .background(pokemon.color)
    }
}

struct PokemonSpriteGrid: View {
    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 3)
    @State var sprites: PokemonSprites

    var body: some View {
        GroupBox("Sprites") {
            LazyVGrid(columns: gridItems) {
                ForEach(sprites.sprites.sorted(by: <), id: \.key) { value in
                    PokemonSprite(image: value.value, subtitle: value.key)
                }
            }
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
        }.frame(height: 250.0)
    }
}

struct WeaknessView: View {
    @State var types: RealmSwift.List<PokemonType>

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("0x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.isImmuneTo) { isImmuneTo in
                    PokemonTypeIndicator(type: isImmuneTo)
                        .frame(height: 32)
                }
            }

            GridRow {
                Text("1/4x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.isDoubleResistanceAgainst) { doubleResistenceTo in
                    PokemonTypeIndicator(type: doubleResistenceTo)
                        .frame(height: 32)
                }
            }

            GridRow {
                Text("1/2x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.isResistanceAgainst) { resistenceTo in
                    PokemonTypeIndicator(type: resistenceTo)
                        .frame(height: 32)
                }
            }

            GridRow(alignment: .center) {
                Text("1x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.hasNormalDamageAgainst) { normalDamage in
                    PokemonTypeIndicator(type: normalDamage)
                        .frame(height: 32)
                }
            }

            GridRow {
                Text("2x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.isWeakTo) { weakTo in
                    PokemonTypeIndicator(type: weakTo)
                        .frame(height: 32)
                }
            }

            GridRow {
                Text("4x")
                    .font(.caption2)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .cornerRadius(.infinity)
                ForEach(types.isDoubleWeakTo) { doubleWeakTo in
                    PokemonTypeIndicator(type: doubleWeakTo)
                        .frame(height: 32)
                }
            }
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
