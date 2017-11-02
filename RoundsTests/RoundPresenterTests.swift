//
//  RoundPresenterTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class RoundPresenterTests: XCTestCase {
    
    final class RoundPresenterMock : RoundPresenter {
        var rounds: [Int] = []
        func renderRounds(value: Int) {
            rounds.append(value)
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
    
    func testNotifyRoundPresenter() {
        // given
        let presenter = RoundPresenterMock()
        appContext.createEntity().set(RoundPresenterComponent(ref: presenter))
        let system = NotifyRoundPresenterOnValueChangeSystem()
        
        // when
        ctx.createEntity().set(NumberOfRoundsComponent(value: 3))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.rounds[0], 3)
        
        // when
        ctx.createEntity().set(NumberOfRoundsComponent(value: 5))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.rounds[0], 3)
        XCTAssertEqual(presenter.rounds[1], 5)
    }
    
    func testDoesNotCrashWhenValueNotPresenet(){
        // given
        let presenter = RoundPresenterMock()
        appContext.createEntity().set(RoundPresenterComponent(ref: presenter))
        let system = NotifyRoundPresenterOnValueChangeSystem()
        
        // when
        system.execute()
        
        // then no crash
        
        // when
        let e = ctx.createEntity().set(NumberOfRoundsComponent(value: 5))
        e.destroy()
        system.execute()
        
        // then no crash
    }
    
    func testInitValue() {
        // given
        let presenter = RoundPresenterMock()
        ctx.createEntity().set(NumberOfRoundsComponent(value: 3))
        let system = InitValuePresentersSystem()
        
        // when
        appContext.createEntity().set(RoundPresenterComponent(ref: presenter))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.rounds[0], 3)
    }
}
