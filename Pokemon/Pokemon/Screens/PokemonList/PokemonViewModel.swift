//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import Foundation

class PokemonViewModel {
    var delegate: PokemonListViewModelDelegate?
    var service: IPokemonService?
    init(service: IPokemonService) {
        self.service = service
    }
}

extension PokemonViewModel: PokemonListViewModelProtocol {
   
    func load(path: Int) {
        delegate?.handleOutPut(.isLoading(false))
        service?.fetchAllData(path: path, onSuccess: { [delegate] data in
            delegate?.handleOutPut(.isLoading(true))
            delegate?.handleOutPut(.pokemonList(data))
        })
    }
    
    
}
