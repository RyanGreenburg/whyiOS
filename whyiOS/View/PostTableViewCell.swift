//
//  PostTableViewCell.swift
//  whyiOS
//
//  Created by RYAN GREENBURG on 2/6/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    weak var delegate: PostTableViewCellDelegate?
    
    func update(withPost post: Post?) {
        guard let post = post else { return }
        self.post = post
        nameLabel.text = post.name
        cohortLabel.text = post.cohort
        reasonLabel.text = post.reason
    }
}

protocol PostTableViewCellDelegate: class {
    
}
