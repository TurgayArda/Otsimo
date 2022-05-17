//
//  PokemonModel.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let forms: [Species]
    let sprites: Sprites
    let stats: [Stat]


    enum CodingKeys: String, CodingKey {
        case forms
        case sprites
        case stats
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}


// MARK: - Sprites
class Sprites: Codable {
    let other: Other?


    enum CodingKeys: String, CodingKey {
        case other
    }
}

// MARK: - Other
struct Other: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}
