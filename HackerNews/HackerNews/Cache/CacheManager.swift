//
//  CacheManager.swift
//  HackerNews
//
//  Created by Alexander Ge on 29/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct CacheManager {
    
    private let directoryPath: String = "hackernewscache/"
    
    init() {
        let directoryURL = cacheDirectoryURL(for: "")
        var x: ObjCBool = true
        if !FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &x) {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveToCache(item: Item) {
        let url = cacheDirectoryURL(for: String(item.id))
        do {
            let data = try JSONEncoder().encode(item)
            try data.write(to: url, options: .atomic)
        } catch {
            print(error)
            assertionFailure("Failed to save to cache")
        }
    }
    
    func loadFromCache(itemID: String) -> Item? {
        let url = cacheDirectoryURL(for: itemID)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(Item.self, from: data)
            
            return decoded
        } catch {
            assertionFailure("Could not decode")
        }
        return nil
    }
    
    private func cacheDirectoryURL(for ID: String) -> URL {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: path).appendingPathComponent(directoryPath + ID)
    }
}

#if DEBUG
extension CacheManager {
    var exposedCacheDirectory: URL {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: path).appendingPathComponent(directoryPath)
    }
}
#endif
