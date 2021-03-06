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

@MainActor class PokedexViewModel: ObservableObject {
    private let pokemonAPI = PokemonAPI()

    @Environment(\.realm) var realm
    @ObservedResults(Pokemon.self) var pokemonRealm
    @Published var pokemons: Results<Pokemon>?

    func loadPokemons() async {
        struct PokemonEntry {
            let pokemon: PKMPokemon
            let species: PKMPokemonSpecies
        }

        pokemons = pokemonRealm.freeze()

        guard let pokemonEntries = try? await pokemonAPI.gameService.fetchPokedex(1).pokemonEntries else { return }
        for entry in pokemonEntries {
            guard let pokemonID = entry.entryNumber, !pokemonRealm.contains(where: { pokemon in
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
            newPokemon.generation = Generation(rawValue: species.generation?.name ?? "")
            newPokemon.captureRate = species.captureRate ?? 0
            newPokemon.hatchCounter = species.hatchCounter ?? -1
            newPokemon.weight = pokemon.weight ?? 0
            newPokemon.genderRate = species.genderRate ?? -1
            newPokemon.infoText = species.flavorTextEntries?.first(where: { $0.language?.name == "de" })?.flavorText
            newPokemon.formText = species.formDescriptions?.first(where: { $0.language?.name == "de" })?.description

            newPokemon.formsSwitchable = species.formsSwitchable ?? false
            newPokemon.hasGenderDifferences = species.hasGenderDifferences ?? false
            newPokemon.isBaby = species.isBaby ?? false

            for stat in stats {
                guard let category = stat.stat?.name, let baseValue = stat.baseStat else { continue }
                newPokemon.stats.insert(PokemonStat(category: category, baseValue: baseValue))
            }

            newPokemon.types.insert(contentsOf: types, at: 0)
            newPokemon.languages.insert(contentsOf: languages, at: 0)

            realm.beginAsyncWrite {
                self.realm.create(Pokemon.self, value: newPokemon, update: .all)
                self.realm.commitAsyncWrite { _ in
                    self.pokemons = self.pokemonRealm.freeze()
                }
            }
        }
    }
}
