//
//  ViewController.swift
//  Rounds
//
//  Created by Maxim Zaks on 20.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ButtonsPresenter {

    override func viewDidLoad() {
        super.viewDidLoad()
        appContext.setUniqueComponent(ButtonsPresenterComponent(ref: self))
    }

    @IBOutlet var greenButton: UIButton?
    @IBOutlet var redButton: UIButton?
    
    @IBAction func greenButtonPressed() {
        ctx.setUniqueComponent(GreenButtonPressedComponent())
    }
    
    @IBAction func redButtonPressed() {
        ctx.setUniqueComponent(RedButtonPressedComponent())
    }
    
    func redButton(enabled: Bool) {
        redButton?.isEnabled = enabled
    }
    
    func greenButton(label: String) {
        greenButton?.setTitle(label, for: .normal)
    }
    
    func redButton(label: String) {
        redButton?.setTitle(label, for: .normal)
    }
}

