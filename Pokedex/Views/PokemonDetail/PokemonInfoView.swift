//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 01.07.22.
//

import SwiftUI

struct PokeDetailInfo: View {
    @State var dictionary: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            VStack(spacing: 0) {
                ForEach(dictionary.filter({ _ in true }), id: \.key) { value in
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
            .cornerRadius(8.0)
        }
    }
}

struct PokemonInfoView: View {
    @State var pokemon: Pokemon

    var body: some View {
        VStack(spacing: 16.0) {
            GroupBox("Allgemeine Informationen") {
                PokeDetailInfo(dictionary: [
                    "Generation": pokemon.generation?.localizedName,
                    "Spiel": pokemon.generation?.gameName,
                    "Region": pokemon.generation?.regionName,
                    "Gewicht": "\(Double(pokemon.weight)/10.0) kg",
                    "Kategorie": pokemon.genum,
                    "Fangrate": "\(pokemon.captureRate)",
                    "Ei-Zyklen": "\(pokemon.hatchCounter)",
                    "Geschlecht": pokemon.genderDescription
                ].compactMapValues { $0 })
            }

            GroupBox("Auf anderen Sprachen") {
                PokeDetailInfo(dictionary: pokemon.languagesDictionary)
            }
        }
    }
}
