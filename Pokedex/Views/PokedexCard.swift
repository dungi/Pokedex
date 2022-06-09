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
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .foregroundColor(.white)

                Text("#\(pokemon.number)")
                    .font(.subheadline).bold()
                    .foregroundColor(.white)

                LazyImage(source: pokemon.image) { state in
                    if let image = state.image {
                        image
                    } else if state.error != nil {
                        Color.red
                    } else {
                        Color.clear
                    }
                }
                .aspectRatio(contentMode: .fit)
            }
            .padding(16)
        }
        .background(pokemon.color)
        .cornerRadius(8)
        .shadow(radius: 2)
        .frame(minHeight: 120)
    }
}
