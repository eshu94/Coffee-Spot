//
//  Order.swift
//  Coffee-Spot
//
//  Created by ESHITA on 01/02/21.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case americano
    case espresso
    case mocha
    case latte
    case cortado
    case irish
    case frappuccino
    case macchiato
    case dalgona
    case turkish
}

enum CoffeeSize: String, Codable, CaseIterable{
    case large
    case medium
    case small
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    
    init?(_ vm: AddCoffeeOrderViewModel){
        guard let name = vm.name,
              let email = vm.email,
              let type = CoffeeType(rawValue: vm.selectedType!.lowercased()),
              let size = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = type
        self.size = size
        
        
    }
    
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Url is incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error in emcoding coffee order data")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        return resource
        
    }
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("Url is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
}

