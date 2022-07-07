//
//  WeaknessView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 01.07.22.
//

import RealmSwift
import SwiftUI

struct WeaknessRow: View {
    @State var damage: String
    @State var types: [PokemonType]

    var tintColor: Color

    var body: some View {
        GridRow(alignment: .center) {
            Text(damage)
                .font(.caption2)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .background(tintColor)
                .cornerRadius(.infinity)
            ForEach(types) { type in
                PokemonTypeIndicator(type: type)
                    .frame(height: 24)
            }
        }
    }
}

struct WeaknessView: View {
    @State var types: RealmSwift.List<PokemonType>
    var tintColor: Color

    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 4.0) {
            WeaknessRow(damage: "0x", types: types.isImmuneTo, tintColor: tintColor)
            WeaknessRow(damage: "¼x", types: types.isDoubleResistanceAgainst, tintColor: tintColor)
            WeaknessRow(damage: "½x", types: types.isResistanceAgainst, tintColor: tintColor)
            WeaknessRow(damage: "1x", types: types.hasNormalDamageAgainst, tintColor: tintColor)
            WeaknessRow(damage: "2x", types: types.isWeakTo, tintColor: tintColor)
            WeaknessRow(damage: "4x", types: types.isDoubleWeakTo, tintColor: tintColor)
        }
    }
}
