//
//  TimeSystemsTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 01.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class TimeSystemsTests: XCTestCase {
    
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
    
    func testSetRoundProgression() {
        // given
        let system = SetRoundProgressSystem()
        ctx.setUniqueComponent(AppStateComponent(value: .running))
        ctx.setUniqueComponent(DeltaTimeComponent(value: 0.5))
        
        let e = ctx.createEntity()
        e += CurrentRoundComponent()
        
        // when
        system.execute()
        
        // then
        XCTAssertEqual(e.get(RoundProgressComponent.self)?.value, 0.5)
        
        // when
        ctx.setUniqueComponent(DeltaTimeComponent(value: 0.75))
        system.execute()
        
        // then
        XCTAssertEqual(e.get(RoundProgressComponent.self)?.value, 1.25)
    }
    
    func testSetCurrentSecond() {
        // given
        let system = ChangeCurrentSecondSystem()
        
        let e = ctx.createEntity()
        
        // when
        e += RoundProgressComponent(value: 1.5)
        system.execute()
        
        // then
        XCTAssertEqual(e.get(CurrentSecondComponent.self)?.value, 1)
        
        // when
        e += RoundProgressComponent(value: 2.7)
        system.execute()
        
        // then
        XCTAssertEqual(e.get(CurrentSecondComponent.self)?.value, 2)
    }
    
    func testSwitchRounds() {
        // given
        let system = SwitchRoundsSystem()
        ctx.setUniqueComponent(AppStateComponent(value: .running))
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 2))
        ctx.setUniqueComponent(OnTimeComponent(value: 10))
        ctx.setUniqueComponent(OffTimeComponent(value: 5))
        ctx.setUniqueComponent(InitTimeComponent(value: 3))
        
        let e1 = ctx.createEntity()
            .set(CurrentRoundComponent())
            .set(RoundTypeComponent(value: .setup))
        
        let e2 = ctx.createEntity()
            .set(RoundTypeComponent(value: .work))
            .set(RoundIndexComponent(value: 1))
        
        let e3 = ctx.createEntity()
            .set(RoundTypeComponent(value: .workWithoutRest))
            .set(RoundIndexComponent(value: 2))
        
        // when
        e1.set(RoundProgressComponent(value: 3.0))
        system.execute()
        
        // then
        XCTAssertEqual(e1.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e2.has(CurrentRoundComponent.cid), true)
        XCTAssertEqual(e3.has(CurrentRoundComponent.cid), false)
        
        // when
        e2.set(RoundProgressComponent(value: 10.0))
        system.execute()
        
        // then
        XCTAssertEqual(e1.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e2.has(CurrentRoundComponent.cid), true)
        XCTAssertEqual(e3.has(CurrentRoundComponent.cid), false)
        
        // when
        e2.set(RoundProgressComponent(value: 15.0))
        system.execute()
        
        // then
        XCTAssertEqual(e1.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e2.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e3.has(CurrentRoundComponent.cid), true)
        
        // when
        e3.set(RoundProgressComponent(value: 10.0))
        system.execute()
        
        // then
        XCTAssertEqual(e1.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e2.has(CurrentRoundComponent.cid), false)
        XCTAssertEqual(e3.has(CurrentRoundComponent.cid), false)
    }
    
    final class RoundProgressPresenterMock: RoundProgressPresenter {
        var presented = 0
        func presentProgress() {
            presented += 1
        }
    }
    
    func testRenderProgress() {
        // given
        let system = RenderProgressSystem()
        let presenter = RoundProgressPresenterMock()
        appContext.createEntity().set(RoundProgressPresenterComponent(ref: presenter))
        
        // when
        ctx.createEntity().set(CurrentSecondComponent(value: 5))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.presented, 1)
    }
}
