//
//  PagesTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 02.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class PagesTests: XCTestCase {
    
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
    
    func testRoundsSelection() {
        // given
        let vc = RoundsSelectionVC()
        vc.valueLabel = UILabel()
        let roundPresenters = appContext.all([RoundPresenterComponent.cid])
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssertEqual(roundPresenters.count, 1)
        let presenter = roundPresenters.sorted()[0].get(RoundPresenterComponent.self)?.ref
        XCTAssert(presenter === vc)
        
        // when
        presenter?.renderRounds(value: 5)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "5")
    }
    
    func testOnTimeSelection() {
        // given
        let vc = OnTimeSelectionVC()
        vc.valueLabel = UILabel()
        let ontTimePresenters = appContext.all([OnTimePresenterComponent.cid])
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssertEqual(ontTimePresenters.count, 1)
        let presenter = ontTimePresenters.sorted()[0].get(OnTimePresenterComponent.self)?.ref
        XCTAssert(presenter === vc)
        
        // when
        presenter?.render(onTime: 15)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "15s")
    }
    
    func testOffTimeSelection() {
        // given
        let vc = OffTimeSelectionVC()
        vc.valueLabel = UILabel()
        let offTimePresenters = appContext.all([OffTimePresenterComponent.cid])
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssertEqual(offTimePresenters.count, 1)
        let presenter = offTimePresenters.sorted()[0].get(OffTimePresenterComponent.self)?.ref
        XCTAssert(presenter === vc)
        
        // when
        presenter?.render(offTime: 5)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "5s")
    }
    
    func testInitTimeSelection() {
        // given
        let vc = InitTimeSelectionVC()
        vc.valueLabel = UILabel()
        let initTimePresenters = appContext.all([InitTimePresenterComponent.cid])
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssertEqual(initTimePresenters.count, 1)
        let presenter = initTimePresenters.sorted()[0].get(InitTimePresenterComponent.self)?.ref
        XCTAssert(presenter === vc)
        
        // when
        presenter?.render(initTime: 2)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "2s")
    }
    
    func testSelectionSummaryInit() {
        // given
        let vc = SelectionSummaryVC()
        let roundPresenters = appContext.all([RoundPresenterComponent.cid])
        let onTimePresenters = appContext.all([OnTimePresenterComponent.cid])
        let offTimePresenters = appContext.all([OffTimePresenterComponent.cid])
        let initTimePresenters = appContext.all([InitTimePresenterComponent.cid])
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssertEqual(roundPresenters.count, 1)
        XCTAssertEqual(onTimePresenters.count, 1)
        XCTAssertEqual(offTimePresenters.count, 1)
        XCTAssertEqual(initTimePresenters.count, 1)
        
        let presenter1 = roundPresenters.sorted()[0].get(RoundPresenterComponent.self)?.ref
        let presenter2 = onTimePresenters.sorted()[0].get(OnTimePresenterComponent.self)?.ref
        let presenter3 = offTimePresenters.sorted()[0].get(OffTimePresenterComponent.self)?.ref
        let presenter4 = initTimePresenters.sorted()[0].get(InitTimePresenterComponent.self)?.ref
        
        XCTAssert(presenter1 === vc)
        XCTAssert(presenter2 === vc)
        XCTAssert(presenter3 === vc)
        XCTAssert(presenter4 === vc)
    }
    
    func testSelectionSummaryPresentProgrees() {
        // given
        let vc = SelectionSummaryVC()
        vc.headerLabel = UILabel()
        vc.valueLabel = UILabel()
        let e = ctx.createEntity()
        e += CurrentRoundComponent()
        e += CurrentSecondComponent(value: 3)
        e += RoundTypeComponent(value: .setup)
        
        MainContext.numberOfRounds = 2
        MainContext.onTime = 15
        MainContext.offTime = 5
        MainContext.initTime = 4
        
        // when
        vc.presentProgress()
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "Start in")
        XCTAssertEqual(vc.valueLabel.text, "1s")
        
        // when
        e += RoundTypeComponent(value: .work)
        e += RoundIndexComponent(value: 1)
        vc.presentProgress()
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "Work 1/2")
        XCTAssertEqual(vc.valueLabel.text, "12s")
        
        // when
        e += CurrentSecondComponent(value: 17)
        vc.presentProgress()
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "Relax 1/2")
        XCTAssertEqual(vc.valueLabel.text, "3s")
        
        // when
        e += CurrentSecondComponent(value: 1)
        e += RoundTypeComponent(value: .workWithoutRest)
        e += RoundIndexComponent(value: 2)
        vc.presentProgress()
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "Work (last round)")
        XCTAssertEqual(vc.valueLabel.text, "14s")
    }
    
    func testSelectionSummaryTotalTime() {
        // given
        let vc = SelectionSummaryVC()
        vc.headerLabel = UILabel()
        vc.valueLabel = UILabel()
        
        // when
        // passed through value does not matter,
        // just trying default case which set all values to min
        vc.render(initTime: 0)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "0m 05s")
        
        // when
        MainContext.numberOfRounds = 2
        MainContext.onTime = 15
        MainContext.offTime = 5
        MainContext.initTime = 4
        vc.render(initTime: 4)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "0m 39s")
        
        // when
        MainContext.offTime = 15
        vc.render(offTime: 15)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "0m 49s")
        
        // when
        MainContext.onTime = 25
        vc.render(onTime: 25)
        
        // then
        XCTAssertEqual(vc.valueLabel.text, "1m 09s")
        
        // when
        MainContext.numberOfRounds = 3
        vc.renderRounds(value: 3)
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "3 rounds")
        XCTAssertEqual(vc.valueLabel.text, "1m 49s")
        
        // when
        MainContext.numberOfRounds = 1
        vc.renderRounds(value: 1)
        
        // then
        XCTAssertEqual(vc.headerLabel.text, "1 round")
        XCTAssertEqual(vc.valueLabel.text, "0m 29s")
    }
}
