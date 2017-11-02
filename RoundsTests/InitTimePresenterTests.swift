//
//  InitTimePresenterTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class InitTimePresenterTests: XCTestCase {
    
    final class InitTimePresenterMock : InitTimePresenter {
        var values: [Int] = []
        func render(initTime: Int) {
            values.append(initTime)
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
        let presenter = InitTimePresenterMock()
        appContext.createEntity().set(InitTimePresenterComponent(ref: presenter))
        let system = NotifyInitTimePresenterOnValueChangeSystem()
        
        // when
        ctx.createEntity().set(InitTimeComponent(value: 3))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        
        // when
        ctx.createEntity().set(InitTimeComponent(value: 5))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        XCTAssertEqual(presenter.values[1], 5)
    }
    
    func testDoesNotCrashWhenValueNotPresent() {
        // given
        let presenter = InitTimePresenterMock()
        appContext.createEntity().set(InitTimePresenterComponent(ref: presenter))
        let system = NotifyInitTimePresenterOnValueChangeSystem()
        
        // when
        system.execute()
        
        // then no crash
        
        // when
        let e = ctx.createEntity().set(InitTimeComponent(value: 5))
        e.destroy()
        system.execute()
        
        // then no crash
    }
    
    func testInitValue() {
        // given
        let presenter = InitTimePresenterMock()
        ctx.createEntity().set(InitTimeComponent(value: 15))
        let system = InitValuePresentersSystem()
        
        // when
        appContext.createEntity().set(InitTimePresenterComponent(ref: presenter))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 15)
    }
}
