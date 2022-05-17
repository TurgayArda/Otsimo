//
//  NetworkConstant.swift
//  Pokemon
//
//  Created by ArdaSisli on 17.05.2022.
//

import Foundation

enum NetworkConstant: String {
case path_url = "https://pokeapi.co/api/v2"
case pokemon_url = "/pokemon/"

static func pokemonListPath(path: Int) -> String {
    return "\(path_url.rawValue)\(pokemon_url.rawValue)\(path)"
}
}
