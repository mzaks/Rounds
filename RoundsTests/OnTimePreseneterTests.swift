//
//  OnTimePreseneterTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class OnTimePreseneterTests: XCTestCase {
    
    final class OnTimePresenterMock : OnTimePresenter {
        var values: [Int] = []
        func render(onTime: Int) {
            values.append(onTime)
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
        let presenter = OnTimePresenterMock()
        appContext.createEntity().set(OnTimePresenterComponent(ref: presenter))
        let system = NotifyOnTimePresenterOnValueChangeSystem()
        
        // when
        ctx.createEntity().set(OnTimeComponent(value: 3))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        
        // when
        ctx.createEntity().set(OnTimeComponent(value: 5))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 3)
        XCTAssertEqual(presenter.values[1], 5)
    }
    
    func testDoesNotCrashWhenValueNotPresent() {
        // given
        let presenter = OnTimePresenterMock()
        appContext.createEntity().set(OnTimePresenterComponent(ref: presenter))
        let system = NotifyOnTimePresenterOnValueChangeSystem()
        
        // when
        system.execute()
        
        // then no crash
        
        // when
        let e = ctx.createEntity().set(OnTimeComponent(value: 5))
        e.destroy()
        system.execute()
        
        // then no crash
    }
    
    func testInitValue() {
        // given
        let presenter = OnTimePresenterMock()
        ctx.createEntity().set(OnTimeComponent(value: 5))
        let system = InitValuePresentersSystem()
        
        // when
        appContext.createEntity().set(OnTimePresenterComponent(ref: presenter))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.values[0], 5)
    }
}
