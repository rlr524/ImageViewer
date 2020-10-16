//
//  ViewController.swift
//  ImageViewer
//
//  Created by Rob Ranf on 9/18/20.
//

import UIKit

class ViewController: UITableViewController, UIActivityItemSource {
    // This is a placeholder that tells UIKit what type of data we want to share
    // on our recommend button on the main VC. We're telling it we want to share
    // a string. The return value is unimportant, as long as it's a string. In this
    // case we're just using the same value as what we actually pass for the
    // message subject line.
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Hello, Madison"
    }
    
    // This is the function that actually prefills our message text when
    // we recommend the app.
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return "Hello, Madison!"
    }
    
    // This function prefills our message subject line when we recomment the app. This appears
    // to only work with the Apple mail app, not 3P mail apps like Gmail or Outlook.
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Secret message!"
    }
    
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                images.append(item)
            }
        }
        images.sort(by: <)
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
            vc.imageCount = images.count
            // The indexpath.row is a string identifying the title in the index
            // position of the row we choose. We convert it to an int and
            // add one to it to identify an image number, e.g. 1 - 10, instead of
            // an index location in the array of images
            vc.selectedImageIndex = Int((indexPath.row) + 1)
            // 3. Now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // This function allows us to share the app itself via message, mail, etc.
    @objc func recommendApp() {
        let item = [self]
        let ac = UIActivityViewController(activityItems: item, applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

