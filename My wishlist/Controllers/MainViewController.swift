//
//  ViewController.swift
//  My wishlist
//
//  Created by Дмитрий on 17.09.2020.
//  Copyright © 2020 NoCompany. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wishTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }


}

