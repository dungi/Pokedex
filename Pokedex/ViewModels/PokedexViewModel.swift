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

    struct PokemonEntry {
        let pokemon: PKMPokemon
        let species: PKMPokemonSpecies
    }

    func loadPokemons() async {
        guard let pokemonEntries = try? await pokemonAPI.gameService.fetchPokedex(1).pokemonEntries else { return }

        var pokemons: [Pokemon] = []
        for entry in pokemonEntries {
            guard let pokemonID = entry.entryNumber, !pokemon.contains(where: { pokemon in
                pokemonID == pokemon.id
            }) else { continue }
            async let fetchSpecies = pokemonAPI.pokemonService.fetchPokemonSpecies(pokemonID)
            async let fetchPokemon = pokemonAPI.pokemonService.fetchPokemon(pokemonID)
            guard let pokemonEntry = try? await PokemonEntry(pokemon: fetchPokemon, species: fetchSpecies) else { continue }

            let species = pokemonEntry.species
            let pokemon = pokemonEntry.pokemon

            let newPokemon = Pokemon()

            pokemon.stats?.forEach { stat in
                guard let category = stat.stat?.name, let baseValue = stat.baseStat else { return }
                newPokemon.stats.insert(PokemonStat(category: category, baseValue: baseValue))
            }

            guard let colorName = species.color?.name,
                  let pokemonID = species.id ?? pokemon.id,
                  let sprites = pokemon.sprites,
                  let name = species.names?.first(where: { $0.language?.name == "de" })?.name
            else { continue }

            newPokemon.id = pokemonID
            newPokemon.name = name
            newPokemon.colorName = colorName
            newPokemon.sprites = PokemonSprites(sprites: sprites)

            pokemon.types?
                .compactMap { $0.type?.name }
                .forEach { type in
                    newPokemon.types.insert(type)
                }

            pokemons.append(newPokemon)
        }

        do {
            try realm.write {
              realm.add(pokemons)
            }
        } catch {
            print("ERROR", error.localizedDescription)
        }
    }
}

