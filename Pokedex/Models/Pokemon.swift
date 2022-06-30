//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 17.06.22.
//

import RealmSwift
import PokemonAPI
import SwiftUI

enum Generation: String, PersistableEnum {
    case one = "generation-i"
    case two = "generation-ii"
    case three = "generation-iii"
    case four = "generation-iv"
    case five = "generation-v"
    case six = "generation-vi"
    case seven = "generation-vii"
    case eight = "generation-viii"

    var localizedName: String {
        switch self {
        case .one:
            return "1. Generation"
        case .two:
            return "2. Generation"
        case .three:
            return "3. Generation"
        case .four:
            return "4. Generation"
        case .five:
            return "5. Generation"
        case .six:
            return "6. Generation"
        case .seven:
            return "7. Generation"
        case .eight:
            return "8. Generation"
        }
    }

    var gameName: String {
        switch self {
        case .one:
            return "Rot & Blau"
        case .two:
            return "Silber & Gold"
        case .three:
            return "Rubin & Sapahir"
        case .four:
            return "Diamant & Perle"
        case .five:
            return "Schwarz & Weiß"
        case .six:
            return "X & Y"
        case .seven:
            return "Sonne & Mond"
        case .eight:
            return "Schwert & Schild"
        }
    }

    var regionName: String {
        switch self {
        case .one:
            return "Kanto"
        case .two:
            return "Johto"
        case .three:
            return "Hoenn"
        case .four:
            return "Sinnoh"
        case .five:
            return "Unova"
        case .six:
            return "Kalos"
        case .seven:
            return "Alola"
        case .eight:
            return "Galar"
        }
    }
}

class Pokemon: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var infoText: String?
    @Persisted var formText: String?

    @Persisted var weight: Int
    @Persisted var colorName: String
    @Persisted var genum: String
    @Persisted var generation: Generation?

    @Persisted var hatchCounter: Int
    @Persisted var genderRate: Int = -1
    @Persisted var captureRate: Int

    @Persisted var formsSwitchable: Bool = false
    @Persisted var hasGenderDifferences: Bool = false
    @Persisted var isBaby: Bool = false

    @Persisted var languages = RealmSwift.List<PokemonLanguage>()
    @Persisted var types = RealmSwift.List<PokemonType>()
    @Persisted var stats: MutableSet<PokemonStat>
    @Persisted var sprites: PokemonSprites?

    var color: Color {
        let color: Color
        switch colorName {
        case "gray", "white":
            color = Color("sadGray")

        case "blue":
            color = Color("waterBlue")

        case "red":
            color = Color("fireRed")

        case "yellow":
            color = Color("pikaYellow")

        case "green":
            color = Color("leafGreen")

        case "pink":
            color = Color("gumPink")

        case "brown":
            color = Color("beeBrown")

        case "purple":
            color = Color("grapePurple")

        default:
            color = Color("darkBlack")
        }

        return color
    }

    var languagesDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        languages.forEach { language in
            if let localizedLanguage = language.localizedLanguage {
                dictionary[localizedLanguage] = language.name
            }
        }

        return dictionary
    }

    var genderDescription: String {
        let femaleRate = (Double(genderRate) / 8.0) * 100
        let maleRate = (Double(8 - genderRate) / 8.0) * 100

        if genderRate == -1 { // Diverse
            return "Unbekannt"
        } else {
            return "\(maleRate)% ♂️\(femaleRate)% ♀️"
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

    var localizedLanguage: String? {
        switch language {
        case "en":
            return "Englisch"

        case "es":
            return "Spanisch"

        case "fr":
            return "Französisch"

        case "it":
            return "Italienisch"

        case "ja":
            return "Japanisch"

        case "ko":
            return "Koreanisch"

        case "roomaji":
            return "Rōmaji"

        case "zh-Hant":
            return "Chinesisch"

        default:
            return nil
        }
    }

    override init() {}

    init(language: String, name: String) {
        self.language = language
        self.name = name
    }
}
