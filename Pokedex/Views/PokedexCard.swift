//
//  PokedexCard.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import NukeUI
import SwiftUI

struct PokedexCard: View {
    let pokemon: Pokemon

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(alignment: .top) {
                    Text(pokemon.name)
                        .lineLimit(1)
                        .font(.headline).bold()
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.subheadline).italic()
                }
                HStack {
                    Spacer()
                    ForEach(pokemon.types) { type in
                        PokemonTypeIndicator(type: type)
                            .frame(height: 32)
                    }
                }
                LazyImage(source: pokemon.sprites?.frontDefault) { state in
                    if let image = state.image {
                        image
                    } else {
                        Color.clear
                    }
                }
                .priority(.veryLow)
                .aspectRatio(contentMode: .fit)
            }
            .padding(16)
        }
        .foregroundColor(.primary)
        .background(pokemon.color)
        .cornerRadius(8)
        .frame(minHeight: 75)
    }
}
