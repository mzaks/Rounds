//
//  EntitasExtensionsTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 02.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class EntitasExtensionsTests: XCTestCase {
    
    final class SystemA: System {}
    
    func testSystemName() {
        let system = SystemA()
        XCTAssertEqual(system.name, "SystemA")
    }
    
}
