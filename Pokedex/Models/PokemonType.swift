//
//  PokemonType.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 30.06.22.
//

import Foundation
import RealmSwift
import SwiftUI

enum PokemonType: String, CaseIterable, Identifiable, PersistableEnum {
    var id: String { rawValue }

    case grass
    case bug
    case fire
    case water
    case ice
    case electric
    case psychic
    case poison
    case fighting
    case ground
    case rock
    case dark
    case ghost
    case steel
    case fairy
    case dragon
    case flying
    case normal

    var isWeakAgainst: [PokemonType] {
        switch self {
        case .grass:
            return [.bug, .fire, .flying, .ice, .poison]
        case .bug:
            return [.fire, .flying, .rock]
        case .fire:
            return [.ground, .rock, .water]
        case .water:
            return [.electric, .grass]
        case .ice:
            return [.fire, .fighting, .rock, .steel]
        case .electric:
            return [.ground]
        case .psychic:
            return [.bug, .ghost, .dark]
        case .poison:
            return [.ground, .psychic]
        case .fighting:
            return [.fairy, .flying, .psychic]
        case .ground:
            return [.water, .grass, .ice]
        case .rock:
            return [.water, .grass, .fighting, .ground, .steel]
        case .dark:
            return [.fighting, .bug, .fairy]
        case .ghost:
            return [.ghost, .dark]
        case .steel:
            return [.fire, .fighting, .ground]
        case .fairy:
            return [.poison, .steel]
        case .dragon:
            return [.dragon, .fairy, .ice]
        case .flying:
            return [.electric, .ice, .rock]
        case .normal:
            return [.fighting]
        }
    }

    var isImmunteTo: [PokemonType] {
        switch self {
        case .ground:
            return [.electric]

        case .fairy:
            return [.dragon]

        case .dark:
            return [.psychic]

        case .steel:
            return [.poison]

        case .flying:
            return [.ground]

        case .ghost:
            return [.normal, .fighting]

        case .normal:
            return [.ghost]
 
        default:
            return []
        }
    }

    var isResistenceAgainst: [PokemonType] {
        switch self {
        case .grass:
            return [.ground, .grass, .water, .electric]
        case .bug:
            return [.fighting, .ground, .grass]
        case .fire:
            return [.fire, .grass, .ice, .bug, .steel]
        case .water:
            return [.steel, .water, .fire, .ice]
        case .ice:
            return [.ice]
        case .electric:
            return [.electric, .steel, .flying]
        case .psychic:
            return [.psychic, .fighting]
        case .poison:
            return [.poison, .fighting, .bug, .grass, .fairy]
        case .fighting:
            return [.rock, .bug, .dark]
        case .ground:
            return [.poison, .rock]
        case .rock:
            return [.normal, .flying, .poison, .fire]
        case .dark:
            return [.dark, .ghost]
        case .ghost:
            return [.fighting, .poison, .bug]
        case .steel:
            return [.normal, .grass, .ice, .flying, .psychic, .bug, .rock, .dragon, .steel, .fairy]
        case .fairy:
            return [.dark, .fighting, .bug]
        case .dragon:
            return [.fire, .water, .grass, .electric]
        case .flying:
            return [.bug, .fighting, .grass]
        case .normal:
            return []
        }
    }

    var backgroundColor: Color {
        switch self {
        case .grass,
            .bug:
            return .green
        case .fire:
            return .orange
        case .water,
            .ice:
            return .blue
        case .electric:
            return .yellow
        case .psychic,
             .poison,
             .ghost:
            return .purple
        case .fighting,
            .ground,
            .rock:
            return .brown
        case .dark:
            return .black
        case .steel:
            return .gray
        case .fairy:
            return .pink
        case .dragon:
            return .indigo
        case .flying:
            return .cyan
        case .normal:
            return .teal
        }
    }
}

extension Array where Element == [PokemonType] {
    func removeDuplicates() -> Set<PokemonType> {
        var elements = self
        var unique: Set<PokemonType> = Set(elements.removeFirst())

        elements.forEach { element in
            unique = unique.symmetricDifference(element)
        }

        return unique
    }

    func onlyTheDuplicates() -> Set<PokemonType> {
        var elements = self
        var unique: Set<PokemonType> = Set(elements.removeFirst())

        elements.forEach { element in
            unique = unique.intersection(element)
        }

        return unique
    }
}

extension RealmSwift.List where Element == PokemonType {
    private func weakTo() -> Set<PokemonType> {
        map(\.isWeakAgainst).removeDuplicates()
    }

    private func resistenceTo() -> Set<PokemonType> {
        map(\.isResistenceAgainst).removeDuplicates()
    }

    private func doubleWeakTo() -> Set<PokemonType> {
        guard count > 1 else { return [] }
        return map(\.isWeakAgainst).onlyTheDuplicates()
    }

    private func doubleResistenceTo() -> Set<PokemonType> {
        guard count > 1 else { return [] }
        return map(\.isResistenceAgainst).onlyTheDuplicates()
    }
    
    private func immuneTo() -> Set<PokemonType> {
        map(\.isImmunteTo).removeDuplicates()
    }

    var isImmuneTo: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return immune
            .filter {
                !resistance.contains($0) &&
                !doubleWeakness.contains($0) &&
                !doubleResistance.contains($0) &&
                !weakness.contains($0)
            }
            .sorted()
    }

    var isWeakTo: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return weakness
            .filter {
                !resistance.contains($0) &&
                !doubleWeakness.contains($0) &&
                !doubleResistance.contains($0) &&
                !immune.contains($0)
            }
            .sorted()
    }

    var isDoubleWeakTo: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return doubleWeakness
            .filter {
                !resistance.contains($0) &&
                !weakness.contains($0) &&
                !doubleResistance.contains($0) &&
                !immune.contains($0)
            }
            .sorted()
    }

    var isResistanceAgainst: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return resistance
            .filter {
                !doubleWeakness.contains($0) &&
                !weakness.contains($0) &&
                !doubleResistance.contains($0) &&
                !immune.contains($0)
            }
            .sorted()
    }

    var isDoubleResistanceAgainst: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return doubleResistance
            .filter {
                !doubleWeakness.contains($0) &&
                !weakness.contains($0) &&
                !resistance.contains($0) &&
                !immune.contains($0)
            }
            .sorted()
    }

    var hasNormalDamageAgainst: [PokemonType] {
        let weakness = weakTo()
        let doubleWeakness = doubleWeakTo()
        let resistance = resistenceTo()
        let doubleResistance = doubleResistenceTo()
        let immune = immuneTo()

        return PokemonType.allCases
            .filter {
                !doubleWeakness.contains($0) &&
                !weakness.contains($0) &&
                !resistance.contains($0) &&
                !immune.contains($0) &&
                !doubleResistance.contains($0)
            }
            .sorted()
    }
}
