//
//  Pods
//
//  Copyright (c) 2019/6/13 linhey - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import Foundation

public class MemoryStrorage {
    
    var cache = NSCache<NSString, AnyObject>()
    
    init() { }
    
}


// MARK: - subscript
public extension MemoryStrorage {
    
    subscript<T: AnyObject>(_ key: String) -> T? {
        set { _ = set(value: newValue, for: key) }
        get { return get(key: key) }
    }
    
}

// MARK: - set / get with Codable
public extension MemoryStrorage {
    
    func set<T: AnyObject>(value: T?, for key: String) -> Bool {
        if let value = value {
            cache.setObject(value, forKey: key as NSString)
        }else {
            remove(key: key)
        }
        return true
    }
    
    func get<T: AnyObject>(key: String) -> T? {
        return cache.object(forKey: key as NSString) as? T
    }
    
}

extension MemoryStrorage {
    
    func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
    
}
