//
//  Pages.swift
//  
//
//  Created by Maxim Zaks on 21.10.17.
//

import UIKit

protocol AppStateVC {
    var state: AppStateComponent.State {get}
}

class RoundsSelectionVC: UIViewController, RoundPresenter, AppStateVC {
    @IBOutlet var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appContext.createEntity().set(RoundPresenterComponent(ref: self))
    }
    func renderRounds(value: Int) {
        valueLabel.text = "\(value)"
    }
    
    let state = AppStateComponent.State.selectRounds
}

class OnTimeSelectionVC: UIViewController, OnTimePresenter, AppStateVC {
    @IBOutlet var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appContext.createEntity().set(OnTimePresenterComponent(ref: self))
    }
    func render(onTime: Int) {
        valueLabel.text = "\(onTime)s"
    }
    let state = AppStateComponent.State.selectOnTime
}

class OffTimeSelectionVC: UIViewController, OffTimePresenter, AppStateVC {
    @IBOutlet var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appContext.createEntity().set(OffTimePresenterComponent(ref: self))
    }
    func render(offTime: Int) {
        valueLabel.text = "\(offTime)s"
    }
    let state = AppStateComponent.State.selectOffTime
}

class InitTimeSelectionVC: UIViewController, InitTimePresenter, AppStateVC {
    @IBOutlet var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appContext.createEntity().set(InitTimePresenterComponent(ref: self))
    }
    func render(initTime: Int) {
        valueLabel.text = "\(initTime)s"
    }
    let state = AppStateComponent.State.selectInitTime
}

import EntitasKit

class SelectionSummaryVC:
                    UIViewController,
                    InitTimePresenter,
                    RoundPresenter,
                    OnTimePresenter,
                    OffTimePresenter,
                    RoundProgressPresenter,
                    AppStateVC {
    
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var headerLabel: UILabel!
    
    let state = AppStateComponent.State.selectSummary
    
    override func viewDidLoad() {
        let e = appContext.createEntity()
        e += InitTimePresenterComponent(ref: self)
        e += RoundPresenterComponent(ref: self)
        e += OnTimePresenterComponent(ref: self)
        e += OffTimePresenterComponent(ref: self)
        e += RoundProgressPresenterComponent(ref: self)
        super.viewDidLoad()
    }
    func render(initTime: Int) {
        setTotalTime()
    }
    func render(onTime: Int) {
        setTotalTime()
    }
    func render(offTime: Int) {
        setTotalTime()
    }
    func renderRounds(value: Int) {
        setTotalTime()
        headerLabel.text = "\(value) \(value == 1 ? "round" : "rounds")"
    }
    
    func presentProgress() {
        guard let e = ctx.uniqueEntity(CurrentRoundComponent.matcher),
            let type = e.get(RoundTypeComponent.self)?.value,
            let progress = e.get(CurrentSecondComponent.self)?.value,
            let rounds = MainContext.numberOfRounds,
            let initTime = MainContext.initTime,
            let onTime = MainContext.onTime,
            let offTime = MainContext.offTime else {
                return
        }
        let index = e.get(RoundIndexComponent.self)?.value ?? 0
        switch type {
        case .setup:
            headerLabel.text = "Start in"
            valueLabel.text = "\(initTime - progress)s"
        case .work:
            if progress < onTime {
                headerLabel.text = "Work \(index)/\(rounds)"
                let newValue = onTime - Int(progress)
                valueLabel.text = "\(newValue)s"
            } else {
                headerLabel.text = "Relax \(index)/\(rounds)"
                valueLabel.text = "\(offTime - (progress - onTime))s"
            }
        case .workWithoutRest:
            headerLabel.text = "Work (last round)"
            valueLabel.text = "\(onTime - progress)s"
        }
    }
    
    private func setTotalTime(){
        let rounds = MainContext.numberOfRounds ?? minNumberOfRounds
        let on = MainContext.onTime ?? minOnTime
        let off = MainContext.offTime ?? minOffTime
        let initTime = MainContext.initTime ?? minInitTime
        
        let time = initTime + (on * rounds) + (off * (rounds - 1))
        let min = time / 60
        let sec = time % 60
        let secString = sec < 10 ? "0\(sec)" : "\(sec)"
        valueLabel.text = "\(min)m \(secString)s"
    }
    
}
