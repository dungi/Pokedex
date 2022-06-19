//
//  PokemonTypeIndicator.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 13.06.22.
//

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

struct PokemonTypeIndicator: View {
    var type: PokemonType
    var body: some View {

        ViewThatFits {
//            HStack {
//                Image(type.rawValue)
//                    .resizable()
//                    .frame(width: 32, height: 32)
//                Text(type.rawValue)
//                    .font(.title3)
//                    .foregroundColor(.white)
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32))
//            }
//            .background(type.backgroundColor)
//            .cornerRadius(.infinity / 2)
            Image(type.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct PokemonTypeIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(PokemonType.allCases) { type in
            PokemonTypeIndicator(type: type)
                .previewDisplayName(type.rawValue.capitalized)
                .environment(\.colorScheme, .dark)
        }
    }
}
