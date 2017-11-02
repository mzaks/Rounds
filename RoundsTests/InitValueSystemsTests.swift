//
//  InitValuesTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 01.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class InitValueSystemsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ctx = Context()
    }
    
    override func tearDown() {
        super.tearDown()
        ctx = Context()
    }
    
    func testInitValues() {
        // given
        let system = InitValuesSystem()
        
        // when
        system.initialise()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value, 4)
        XCTAssertEqual(ctx.uniqueComponent(OnTimeComponent.self)?.value, 20)
        XCTAssertEqual(ctx.uniqueComponent(OffTimeComponent.self)?.value, 10)
        XCTAssertEqual(ctx.uniqueComponent(InitTimeComponent.self)?.value, 3)
    }
    
    func testSetAppToPause() {
        // given
        let system = SetAppStateToPauseSystem()
        ctx.createEntity().set(RoundTypeComponent(value: .setup))
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectSummary))
        system.execute()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .paused)
    }
    
    func testDoNotSetAppToPause() {
        // given
        let system = SetAppStateToPauseSystem()
        ctx.createEntity().set(RoundTypeComponent(value: .setup))
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        system.execute()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .selectRounds)
    }
    
    func testSetAppToPause2() {
        // given
        let system = SetAppStateToPauseSystem()
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectSummary))
        system.execute()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .selectSummary)
    }
}
