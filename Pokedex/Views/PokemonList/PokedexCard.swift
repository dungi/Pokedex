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
                ZStack(alignment: .top) {
                    LazyImage(source: pokemon.sprites?.frontDefault) { state in
                        if let image = state.image {
                            image
                        } else {
                            Color.clear
                        }
                    }
                    .priority(.veryLow)
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgeInsets(top: 24.0, leading: 0, bottom: 0, trailing: 0))
                    HStack {
                        Spacer()
                        ForEach(pokemon.types) { type in
                            PokemonTypeIndicator(type: type)
                                .frame(height: 32)
                        }
                    }
                }
            }
            .padding(16)
        }
        .foregroundColor(.primary)
        .background(pokemon.color)
        .cornerRadius(8)
        .frame(height: 180)
    }
}
