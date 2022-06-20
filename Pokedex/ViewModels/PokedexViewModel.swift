//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import Foundation
import PokemonAPI
import RealmSwift
import SwiftUI

class PokedexViewModel: ObservableObject {
    private let pokemonAPI = PokemonAPI()

    @Environment(\.realm) var realm
    @ObservedResults(Pokemon.self) var pokemon

    func loadPokemons() async {
        struct PokemonEntry {
            let pokemon: PKMPokemon
            let species: PKMPokemonSpecies
        }

        guard let pokemonEntries = try? await pokemonAPI.gameService.fetchPokedex(1).pokemonEntries else { return }
        for entry in pokemonEntries {
            guard let pokemonID = entry.entryNumber, !pokemon.contains(where: { pokemon in
                pokemonID == pokemon.id
            }) else { continue }
            async let fetchSpecies = pokemonAPI.pokemonService.fetchPokemonSpecies(pokemonID)
            async let fetchPokemon = pokemonAPI.pokemonService.fetchPokemon(pokemonID)
            guard let pokemonEntry = try? await PokemonEntry(pokemon: fetchPokemon, species: fetchSpecies) else { continue }

            let species = pokemonEntry.species
            let pokemon = pokemonEntry.pokemon
            guard let colorName = species.color?.name,
                  let pokemonID = species.id ?? pokemon.id,
                  let stats = pokemon.stats,
                  let sprites = pokemon.sprites,
                  let genum = species.genera?.first(where: { $0.language?.name == "de" })?.genus,
                  let genderRate = species.genderRate,
                  let name = species.names?.first(where: { $0.language?.name == "de" })?.name,
                  let types = pokemon.types?
                .compactMap({ $0.type?.name })
                .map({ PokemonType.init(rawValue: $0) }) as? [PokemonType],
                  let languages = species.names?
                .compactMap({ language in
                    PokemonLanguage(language: language.language?.name ?? "", name: language.name ?? "")
                })
            else {
                continue
            }

            let newPokemon = Pokemon()
            newPokemon.id = pokemonID
            newPokemon.name = name
            newPokemon.colorName = colorName
            newPokemon.sprites = PokemonSprites(sprites: sprites)
            newPokemon.genum = genum
            newPokemon.genderRate = genderRate
            newPokemon.infoText = species.flavorTextEntries?.first(where: { $0.language?.name == "de" })?.flavorText
            newPokemon.weight = pokemon.weight ?? 0

            for stat in stats {
                guard let category = stat.stat?.name, let baseValue = stat.baseStat else { continue }
                newPokemon.stats.insert(PokemonStat(category: category, baseValue: baseValue))
            }

            newPokemon.types.insert(contentsOf: types, at: 0)
            newPokemon.languages.insert(contentsOf: languages, at: 0)

            realm.beginAsyncWrite {
                self.realm.create(Pokemon.self, value: newPokemon, update: .all)
                self.realm.commitAsyncWrite()
            }
        }
    }
}
