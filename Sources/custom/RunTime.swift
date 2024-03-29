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

public class RunTime {
    
    public struct Print { }
    
    public static let print = Print()
    
    /// 交换方法
    ///
    /// - Parameters:
    ///   - target: 被交换的方法名
    ///   - replace: 用于交换的方法名
    ///   - classType: 所属类型
    public static func exchange(selector: String, by newSelector: String, class classType: AnyClass) {
        exchange(selector: Selector(selector), by: Selector(newSelector), class: classType)
    }

    /// 交换方法
    ///
    /// - Parameters:
    ///   - selector: 被交换的方法
    ///   - by: 用于交换的方法
    ///   - classType: 所属类型
    public static func exchange(selector: Selector, by newSelector: Selector, class classType: AnyClass) {
        guard let method = class_getInstanceMethod(classType, selector) else {
            assertionFailure("Runtime: 在类: \(classType) 中无法取得对应方法: \(selector.description)")
            return
        }

        guard let newMethod = class_getInstanceMethod(classType, newSelector) else {
            assertionFailure("Runtime: 在类: \(classType) 中无法取得对应方法: \(newSelector.description)")
            return
        }

        let didAddMethod = class_addMethod(classType, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))

        if didAddMethod {
            class_replaceMethod(classType, newSelector, method_getImplementation(method), method_getTypeEncoding(method))
        } else {
            method_exchangeImplementations(method, newMethod)
        }
    }
    
    /// 获取已注册类列表
    ///
    /// - Returns: 已注册类列表
    public static func classList() -> [AnyClass] {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        let list = (0..<typeCount).compactMap { (index) -> AnyClass? in
            return types[index]
        }
        
        types.deinitialize(count: typeCount)
        types.deallocate()
        return list
    }
    
}

public extension RunTime {
    
    /// 获取类型元类
    ///
    /// - Parameter classType: 类型
    /// - Returns: 元类
    static func metaclass(from classType: AnyClass) -> AnyClass? {
        return objc_getMetaClass(String(cString: class_getName(classType))) as? AnyClass
    }
    
    /// 获取该类的实例变量大小
    ///
    /// - Parameter classType: 类型
    /// - Returns: 实例变量大小
    class func instanceSize(from classType: AnyClass) -> Int {
        return class_getInstanceSize(classType)
    }
    
    /// 获取方法列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 方法列表
    class func methods(from classType: AnyClass) -> [Method] {
        var methodNum: UInt32 = 0
        var list = [Method]()
        let methods = class_copyMethodList(classType, &methodNum)
        for index in 0..<numericCast(methodNum) {
            if let met = methods?[index] {
                list.append(met)
            }
        }
        free(methods)
        return list
    }
    
    /// 获取属性列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 属性列表
    class func properties(from classType: AnyClass) -> [objc_property_t] {
        var propNum: UInt32 = 0
        let properties = class_copyPropertyList(classType, &propNum)
        var list = [objc_property_t]()
        for index in 0..<Int(propNum) {
            if let prop = properties?[index] {
                list.append(prop)
            }
        }
        free(properties)
        return list
    }
    
    /// 获取协议列表
    ///
    /// - Parameter classType: 所属类型
    /// - Returns: 协议列表
    class func protocols(from classType: AnyClass) -> [Protocol] {
        var propNum: UInt32 = 0
        let protocols = class_copyProtocolList(classType, &propNum)
        var list = [Protocol]()
        for index in 0..<Int(propNum) {
            if let prop = protocols?[index] {
                list.append(prop)
            }
        }
        return list
    }
    
    /// 成员变量列表
    ///
    /// - Parameter classType: 类型
    /// - Returns: 成员变量
    class func ivars(from classType: AnyClass) -> [Ivar] {
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(classType, &ivarNum)
        var list = [Ivar]()
        for index in 0..<numericCast(ivarNum) {
            if let ivar: objc_property_t = ivars?[index] {
                list.append(ivar)
            }
        }
        free(ivars)
        return list
    }
    
}

public extension RunTime.Print {

    func log(title: String, list: [[String]]) {
        var reList = [[String]](repeating: [String](repeating: "", count: list.count), count: list.first?.count ?? 0)
        for x in 0..<list.count {
            for y in 0..<list[x].count {
                reList[y][x] = list[x][y]
            }
        }

        let maxs = reList.map({ $0.map({ $0.count }) }).map({ $0.max()! })

        let strs = list.map { (line) -> String in
            return "|  " + line.enumerated().map({ (element) -> String in
                return element.element + [String](repeating: " ", count: max(maxs[element.offset] - element.element.count, 0)).joined()
            }).joined(separator: "|") + "  |"
        }

        let count = (strs.first?.count ?? 10) - 2
        debugPrint("+\([String](repeating: "-", count: count).joined())+")
        var title = [String](repeating: " ", count: (count - title.count) / 2).joined() + title
        title = title + [String](repeating: " ", count: count - title.count).joined()
        debugPrint("|\(title)|")
        debugPrint("+\([String](repeating: "-", count: count).joined())+")

        strs.forEach { (str) in
            debugPrint(str)
        }
        debugPrint("+\([String](repeating: "-", count: count).joined())+")
    }
    
    func methods(from classType: AnyClass) {
        let list = RunTime.methods(from: classType).map({ [method_getName($0).description] })
        log(title: "classType", list: list)
    }

    func properties(from classType: AnyClass) {
        let list = RunTime.properties(from: classType).compactMap({ [String(cString: property_getName($0))] })
        log(title: "properties", list: list)
    }
    
    func protocols(from classType: AnyClass) {
        let list = RunTime.protocols(from: classType).map({ [String(cString: protocol_getName($0))] })
        log(title: "protocols", list: list)
    }
    
    func ivars(from classType: AnyClass) {
        let list = RunTime.ivars(from: classType).compactMap({ (item) -> [String]? in
            guard let ivar = ivar_getName(item) else { return nil }
            return [String(cString: ivar)]
        })
        log(title: "ivars", list: list)
    }
    
}
