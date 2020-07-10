//
//  ViewController.swift
//  ImageLibrary
//
//  Created by Aislin Liu on 7/8/20.
//  Copyright © 2020 Aislin Liu. All rights reserved.
//

import UIKit

protocol GallerySelectionDelegate: class {
  func gallerySelected(_ galleryName: String)
}

class TableViewController: UITableViewController {
//
    var currentItems = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    weak var delegate: GallerySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Day")
        makeAddButton()
    }
    
    func makeAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(myRightSideBarButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender: UIBarButtonItem) {
        currentItems += ["Untitled".madeUnique(withRespectTo: currentItems)]
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Day", for: indexPath)
        cell.textLabel?.text = currentItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let selectedGallery = currentItems[indexPath.row]
      delegate?.gallerySelected(selectedGallery)
    }

}
