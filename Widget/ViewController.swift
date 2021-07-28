//
//  ViewController.swift
//  Widget
//
//  Created by Eric Barnes on 7/20/21.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        
        let userDefaults = UserDefaults(suiteName: "group.widgetCache9999") // specific group used to share data between app and widget
        
        guard let text = textField.text, !text.isEmpty else {
            print(" could not get text from textField")
            return
        }
        
        userDefaults?.setValue(text, forKey: "text")
        WidgetCenter.shared.reloadAllTimelines() // tells app to reload widget
    }
}

