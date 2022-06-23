//
//  ItemModel.swift
//  POCProxy
//
//  Created by Javier Pineda Gonzalez on 23/06/22.
//

import UIKit

struct ItemModel: Decodable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "strDrink"
    }
}

struct DrinksModel: Decodable {
    var drinks: [ItemModel]
}
