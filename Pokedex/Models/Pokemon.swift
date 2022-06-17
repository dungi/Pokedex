//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import SwiftUI

struct Pokemon: Identifiable {
    var id: Int

    var name: String
    var number: String {
        "\(id)"
    }

    var color: Color
    var image: String

    var types: [PokemonType]
    var stats: [PokemonStat]
}
