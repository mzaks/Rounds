//
//  AppContext.swift
//  Rounds
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit

var appContext = Context()

protocol RoundPresenter: class {
    func renderRounds(value: Int)
}
protocol OnTimePresenter: class {
    func render(onTime: Int)
}
protocol OffTimePresenter: class {
    func render(offTime: Int)
}
protocol InitTimePresenter: class {
    func render(initTime: Int)
}

protocol ButtonsPresenter: class {
    func redButton(enabled: Bool)
    func greenButton(label: String)
    func redButton(label: String)
}

protocol PagesPresenter: class {
    func showFirstPage()
}

protocol RoundProgressPresenter: class {
    func presentProgress()
}

struct RoundPresenterComponent: Component {
    weak var ref: RoundPresenter?
}
struct OnTimePresenterComponent: Component {
    weak var ref: OnTimePresenter?
}
struct OffTimePresenterComponent: Component {
    weak var ref: OffTimePresenter?
}
struct InitTimePresenterComponent: Component {
    weak var ref: InitTimePresenter?
}

struct ButtonsPresenterComponent: UniqueComponent {
    weak var ref: ButtonsPresenter?
}

struct PagesPresenterComponent: UniqueComponent {
    weak var ref: PagesPresenter?
}

struct RoundProgressPresenterComponent: Component {
    weak var ref: RoundProgressPresenter?
}

enum AppContext {
    static var buttonsPresenter: ButtonsPresenter? {
        return appContext.uniqueComponent(ButtonsPresenterComponent.self)?.ref
    }
    static var pagesPresenter: PagesPresenter? {
        return appContext.uniqueComponent(PagesPresenterComponent.self)?.ref
    }
}
