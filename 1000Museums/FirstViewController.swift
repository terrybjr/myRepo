//
//  FirstViewController.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        theModel.sharedInstance.fetchArtistsFromWeb()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

