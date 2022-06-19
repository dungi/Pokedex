//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 17.06.22.
//

import RealmSwift
import PokemonAPI
import SwiftUI

class Pokemon: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var weight: Int
    @Persisted var colorName: String

    @Persisted var types = RealmSwift.List<PokemonType>()
    @Persisted var stats: MutableSet<PokemonStat>
    @Persisted var sprites: PokemonSprites?

    var color: Color {
        let color: Color
        switch colorName {
        case "gray", "white":
            color = .gray

        case "blue":
            color = .blue

        case "red":
            color = Color("fireRed")

        case "yellow":
            color = .yellow

        case "green":
            color = .green

        case "pink":
            color = .pink

        case "brown":
            color = .brown

        case "purple":
            color = .purple

        default:
            color = .black
        }

        return color
    }
}

class PokemonStat: Object {
    @Persisted var category: String = ""
    @Persisted var baseValue: Int = 0

    override init() {}

    init(category: String, baseValue: Int) {
        self.category = category
        self.baseValue = baseValue
    }
}

class PokemonSprites: Object {
    /// The default depiction of this Pokémon from the front in battle
    @Persisted var frontDefault: String?

    /// The shiny depiction of this Pokémon from the front in battle
    @Persisted var frontShiny: String?

    /// The female depiction of this Pokémon from the front in battle
    @Persisted var frontFemale: String?

    /// The shiny female depiction of this Pokémon from the front
    @Persisted var frontShinyFemale: String?

    /// The default depiction of this Pokémon from the back in battle
    @Persisted var backDefault: String?

    /// The shiny depiction of this Pokémon from the back in battle
    @Persisted var backShiny: String?

    /// The female depiction of this Pokémon from the back in battle
    @Persisted var backFemale: String?

    override init() {}

    init(sprites: PKMPokemonSprites) {
        frontDefault = sprites.frontDefault
        frontShiny = sprites.frontShiny
        frontFemale = sprites.frontFemale
        frontShinyFemale = sprites.frontShinyFemale
        backDefault = sprites.backDefault
        backFemale = sprites.backFemale
    }
}
