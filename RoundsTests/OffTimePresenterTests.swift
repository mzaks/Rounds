//
//  OffTimePresenterTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class OffTimePresenterTests: XCTestCase {
    
    final class OffTimePresenterMock : OffTimePresenter {
        var values: [Int] = []
        func render(offTime: Int) {
            values.append(offTime)
        }
    }
    
    override func setUp() {
        super.setUp()
        ctx = Context()
        appContext = Context()
    }
    
    override func tearDown() {
        super.tearDown()
        ctx = Context()
        appContext = Context()
    }
    
    func testNotifyPresenter() {
        // given
        let presenter = OffTimePresenterMock()
        appContext.createEntity().set(OffTimePresenterComponent(ref: presenter))
        let system = NotifyOffTimePresenterOnValueChangeSystem()
        
        // when
        ctx.createEntity().set(OffTimeComponent(value: 3))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        
        // when
        ctx.createEntity().set(OffTimeComponent(value: 5))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        XCTAssertEqual(presenter.values[1], 5)
    }
    
    func testDoesNotCrashWhenValueNotPresent() {
        // given
        let presenter = OffTimePresenterMock()
        appContext.createEntity().set(OffTimePresenterComponent(ref: presenter))
        let system = NotifyOffTimePresenterOnValueChangeSystem()
        
        // when
        system.execute()
        
        // then no crash
        
        // when
        let e = ctx.createEntity().set(OffTimeComponent(value: 5))
        e.destroy()
        system.execute()
        
        // then no crash
    }
    
    func testInitValue() {
        // given
        let presenter = OffTimePresenterMock()
        ctx.createEntity().set(OffTimeComponent(value: 5))
        let system = InitValuePresentersSystem()
        
        // when
        appContext.createEntity().set(OffTimePresenterComponent(ref: presenter))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 5)
    }
}
