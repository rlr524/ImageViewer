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
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Try loading the "Detail" view controller and typecasting it to be DetailViewController.
        // We use if let: if the optional storyboard (could be nil) fails, or the instantiateViewController fails (could have passed in an invalid Storyboard ID, or the optional "as" fails (could have received back a view controller of a type other than DetailViewController)...if any of these things fail, the code inside the if let block won't execute
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2. Success! Set its selectedImage property. We have access to
            // the selectedImage property that we defined in DetailViewController
            // because we are accessing DetailViewController with the
            // instantiateViewController method above, passing in the "Detail"
            // identifier we assigned as the "Storyboard ID" in the inspector
            vc.selectedImage = images[indexPath.row]
            // 3. Now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

