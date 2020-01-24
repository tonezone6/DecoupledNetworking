//
//  CachedWebservice.swift
//  DecoupledNetworking
//
//  Created by Alex on 20/01/2020.
//  Copyright © 2020 tonezone6. All rights reserved.
//

import Foundation
import CryptoKit

extension Resource {
    var cacheKey: String? {
        guard let data = request.url?.description.data(using: .utf8) else {
            return nil
        }
        return "cache" + Insecure.SHA1.hash(data: data).description
    }
}

struct Cache {
    private let storage: FileStorage
    
    init(storage: FileStorage) {
        self.storage = storage
    }
    
    func load<A: Codable>(_ resource: Resource<A>) -> A? {
        guard resource.isGetRequest, let key = resource.cacheKey else { return nil }
        
        let decoder = JSONDecoder()
        if let data = storage[key] {
            return try? decoder.decode(A.self, from: data)
        }
        return nil
    }
    
    func save<A: Decodable>(_ data: Data, for resource: Resource<A>) {
        guard resource.isGetRequest, let key = resource.cacheKey else { return }
        storage[key] = data
    }
}

struct CachedWebservice {
    private let cache: Cache
    
    init() {
        let storage = FileStorage()
        self.cache = Cache(storage: storage)
    }
    
    func load<A: Codable>(_ resource: Resource<A>, update: @escaping (Result<A, Error>) -> ()) {
        if let result = cache.load(resource) {
            print("cache hit")
            return update(.success(result))
        }
        
        URLSession.shared.load(resource) { result in
            let encoder = JSONEncoder()
            if let value = result, let data = try? encoder.encode(value) {
                self.cache.save(data, for: resource)
                update(.success(value))
            }
        }
    }
}