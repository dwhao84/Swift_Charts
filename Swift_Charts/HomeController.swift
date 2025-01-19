//
//  ViewController.swift
//  Swift_Charts
//
//  Created by Dawei Hao on 2025/1/19.
//

import UIKit
import Charts

class HomeController: UIViewController {
    
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Chart 1", at: 0, animated: true)
        sc.insertSegment(withTitle: "Chart 2", at: 1, animated: true)
        sc.insertSegment(withTitle: "Chart 3", at: 2, animated: true)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    } ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        print("Red Background")
    }


}

