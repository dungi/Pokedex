//
//  SpritesView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 01.07.22.
//

import NukeUI
import SwiftUI

struct PokemonSprite: View {
    var image: String
    var subtitle: String

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: image))
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 124.0)
            Text(subtitle)
                .font(.caption)
        }
    }
}

struct PokemonSpriteGrid: View {
    private let gridItems: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 3)
    @State var sprites: PokemonSprites

    var body: some View {
        GroupBox("Sprites") {
            LazyVGrid(columns: gridItems) {
                ForEach(sprites.sprites, id: \.key) { value in
                    PokemonSprite(image: value.value, subtitle: value.key)
                }
            }
        }
    }
}
