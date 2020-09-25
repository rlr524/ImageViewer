//
//  ViewController.swift
//  ImageViewer
//
//  Created by Rob Ranf on 9/18/20.
//

import UIKit

class ViewController: UITableViewController {
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                images.append(item)
            }
        }
        print(images)
    }
    // Remember, _ is the external name of the first param, tableView is the internal name, and UITableView is the type; same for the second param: numberOfRowsInSection is external, section is internal, and Int is type
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        return cell
    }
}

