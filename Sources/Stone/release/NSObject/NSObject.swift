//
//  Stone
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
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

public extension NSObject {
    
    private struct NSObjectDataKey {
        static let customKeys = UnsafeRawPointer(bitPattern: "com.Stone.customKeys".hashValue)!
    }
    
    /// 存放自定义key-value
    var customKeys: [AnyHashable: Any] {
        get {
            if let value: [AnyHashable: Any] = self.getAssociated(associatedKey: NSObjectDataKey.customKeys) {
                return value
            } else {
                let value: [AnyHashable: Any] = [:]
                self.setAssociated(value: value, associatedKey: NSObjectDataKey.customKeys)
                return value
            }
        }
        set {
            self.setAssociated(value: newValue, associatedKey: NSObjectDataKey.customKeys)
        }
    }
    
}

// MARK: - Runtime
public extension NSObject {
    
    func ivar<T>(for key: String) -> T? {
        guard let ivar = class_getInstanceVariable(type(of: self), key) else { return nil }
        return object_getIvar(self, ivar) as? T
    }
    
    func setAssociated<T>(value: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, associatedKey, value, policy)
    }
    
    func getAssociated<T>(associatedKey: UnsafeRawPointer) -> T? {
        let value = objc_getAssociatedObject(self, associatedKey) as? T
        return value
    }
    
}
