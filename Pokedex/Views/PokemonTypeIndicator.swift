//
//  PokemonTypeIndicator.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 13.06.22.
//

import RealmSwift
import SwiftUI

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
