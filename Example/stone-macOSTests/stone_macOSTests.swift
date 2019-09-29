//
//  stone_macOSTests.swift
//  stone-macOSTests
//
//  Created by linhey on 2019/6/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import Stone
@testable import stone_macOS

extension Collection {



}

class stone_macOSTests: XCTestCase {
    let list_0_9 = [Int](0...9)
    let list_a_z =  (UnicodeScalar("a").value ... UnicodeScalar("z").value).map({ String(UnicodeScalar($0)!) })
}



// MARK: - Array
extension stone_macOSTests {

    func test_array_slice() {
        let list = list_0_9

        do { let range = (0...5);   let passRange = range;   assert(list.slice(range) == [Int](passRange)) }
        do { let range = (1...5);   let passRange = range;   assert(list.slice(range) == [Int](passRange)) }
        do { let range = (-2...5);  let passRange = (0...5); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (-2...20); let passRange = (0...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (5...20);  let passRange = (5...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = ((-10)...(-1)); assert(list.slice(range) == [])  }
        do { let range = (20...50);      assert(list.slice(range) == [])  }

        do { let range = (0..<5);   let passRange = (0...4); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (1..<5);   let passRange = (1...4); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (-2..<5);  let passRange = (0...4); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (-2..<20); let passRange = (0...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (5..<20);  let passRange = (5...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = ((-10)..<(-1)); assert(list.slice(range) == [])  }
        do { let range = (20..<50);      assert(list.slice(range) == [])  }

        do { let range = (..<5);    let passRange = (0...4); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (..<20);   let passRange = (0...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (..<0);    assert(list.slice(range) == []) }

        do { let range = (5...);    let passRange = (5...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (0...);    let passRange = (0...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (20...);   assert(list.slice(range) == []) }

        do { let range = (...5);    let passRange = (0...5); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (...20);   let passRange = (0...9); assert(list.slice(range) == [Int](passRange)) }
        do { let range = (...0);    assert(list.slice(range) == []) }

    }

    func test_array_shuffle() {
        let list = list_0_9
        assert(list.shuffled != list)
        assert(list.shuffled != list.shuffled)
        var temp = list_0_9
        temp.shuffle()
        assert(temp != list)
    }

    func test_array_value() {
        let list = list_0_9
        assert(list.value(at: 0) == 0)
        assert(list.value(at: 9) == 9)
        assert(list.value(at: -1) == 9)
        assert(list.value(at: -9) == 1)
        assert(list.value(at: -20) == nil)
        assert(list.value(at: 20) == nil)
    }

}


// MARK: - WeakBox
extension stone_macOSTests {

    func test_weakBox() {
        let obj = NSObject()
        let count = CFGetRetainCount(obj)
        let box = WeakBox(obj)
        box;
        let count2 = CFGetRetainCount(obj)
        assert(count == count2)
    }

}

// MARK: - Sequence
extension stone_macOSTests {

    

    func test_sequence_count() {
        let list = [Int](0...9)
        assert(list.count({ $0 == 0 }) == 1)
        assert(list.count({ $0 == 5 }) == 1)
        assert(list.count({ $0 == -1 }) == 0)
        assert(list.count({ $0 == 20 }) == 0)
    }


    struct TestKeyPath {
        var id = 0
        var name = ""
    }

    func test_sequence_map_keyPath() {

        let list = list_a_z.enumerated().map({ TestKeyPath(id: $0.offset, name: $0.element) })
        assert(list.map(keyPath: \.id)   == list.map({ $0.id }))
        assert(list.map(keyPath: \.name) == list.map({ $0.name }))
    }

}


public struct SQLiteStorage {




}

// MARK: - Gcd
extension stone_macOSTests {

    func test_Gcd() {
        let expectation = XCTestExpectation(description: "Gcd.delay(label:, seconds:)")
        // 获取转换因子
        var info = mach_timebase_info_data_t()
        mach_timebase_info(&info)
        // 获取开始时间
        let t0 = mach_absolute_time()
        Gcd.delay(label: "label", seconds: 5) {
            // 获取结束时间
            let t1 = mach_absolute_time()
            print(TimeInterval(Int(t1 - t0) * Int(info.numer) / Int(info.denom)) * 1e-9)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 10)
    }

}

// MARK: - Optional
extension stone_macOSTests {

    func test_Optional() {
        let a : Optional<Int> = 0
        assert((try? a.unwrap()) == Optional(0))
    }

}

// MARK: - RunTime
extension stone_macOSTests {

    func test_runtime() {
        RunTime.print.ivars(from: NSView.self)
        RunTime.print.protocols(from: NSView.self)
        RunTime.print.methods(from: NSView.self)
        RunTime.print.properties(from: NSView.self)
    }

}

// MARK: - Sequence
extension stone_macOSTests {

    struct DiskFileStorageCodable: Codable,Equatable {
        var id = ""
        var name = ""
    }

    func test_storage_diskFileStorage() {
        var item = DiskFileStorageCodable()
        item.id = "id"
        item.name = name

        var storage = DiskFileStorage(type: .cache(folder: "user"))
        storage["codable"] = item
        assert(storage["codable"] == item)
    }

}


// MARK: - String slice
extension stone_macOSTests {


}
