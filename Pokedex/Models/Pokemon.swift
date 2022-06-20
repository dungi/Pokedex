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
    @Persisted var infoText: String?

    @Persisted var weight: Int
    @Persisted var colorName: String
    @Persisted var genderRate: Int = -1
    @Persisted var genum: String

    @Persisted var languages = RealmSwift.List<PokemonLanguage>()
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

    var languagesDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        languages.forEach { language in
            dictionary[language.language] = language.name
        }

        return dictionary
    }

    var genderDescription: String {
        let femaleRate = (Double(genderRate) / 8.0) * 100
        let maleRate = (Double(8 - genderRate) / 8.0) * 100

        if genderRate == -1 { // Diverse
            return "Unbekannt"
        } else {
            return "\(maleRate)% ♂ \(femaleRate)% ♀"
        }
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

    var sprites: [String: String] {
        [
            "Vorne": frontDefault ?? "",
            "Shiny Vorne": frontShiny ?? "",
            "Hinten": backDefault ?? "",
            "Hinten Shiny": backShiny ?? "",
            "Weiblich": frontFemale ?? "",
            "Weiblich Shiny": frontShinyFemale ?? "",
            "Weiblich Hinten": backFemale ?? ""
        ].filter {
            $0.value != ""
        }
    }

    override init() {}

    init(sprites: PKMPokemonSprites) {
        frontDefault = sprites.frontDefault
        frontShiny = sprites.frontShiny
        frontFemale = sprites.frontFemale
        frontShinyFemale = sprites.frontShinyFemale
        backDefault = sprites.backDefault
        backFemale = sprites.backFemale
        backShiny = sprites.backShiny
    }
}

class PokemonLanguage: Object {
    @Persisted var language: String
    @Persisted var name: String

    override init() {}

    init(language: String, name: String) {
        self.language = language
        self.name = name
    }
}
