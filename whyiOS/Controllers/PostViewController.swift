//
//  PostViewController.swift
//  whyiOS
//
//  Created by RYAN GREENBURG on 2/6/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var postListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postListTableView.delegate = self
        postListTableView.dataSource = self
        refreshPosts()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        refreshPosts()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addPostAlert()
    }
    
    func refreshPosts() {
        PostController.shared.fetchPosts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.postListTableView.reloadData()
                }
            }
        }
    }
    
    func addPostAlert() {
        var nameTextField: UITextField?
        var cohortTextField: UITextField?
        var reasonTextField: UITextField?
        let controller = UIAlertController(title: "New Post", message: nil, preferredStyle: .alert)
        
        controller.addTextField { (textField) in
            textField.placeholder = "Name..."
            nameTextField = textField
        }
        controller.addTextField { (textField) in
            textField.placeholder = "Cohort..."
            cohortTextField = textField
        }
        controller.addTextField { (textField) in
            textField.placeholder = "Reason..."
            reasonTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.refreshPosts()
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = nameTextField?.text, name != "",
                let cohort = cohortTextField?.text, cohort != "",
                let reason = reasonTextField?.text, reason != "" else { return }
            PostController.shared.postReason(cohort: cohort, name: name, reason: reason, completion: { (success) in
                if success{
                    self.refreshPosts()
                }
            })
        }
        
        controller.addAction(cancelAction)
        controller.addAction(addAction)
        
        present(controller, animated: true, completion: nil)
        
    }
}// End of class

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = PostController.shared.posts[indexPath.row]
        cell.delegate = self
        cell.update(withPost: post)
        
        return cell 
    }
}

extension PostViewController: PostTableViewCellDelegate {
    
}
