//
//  TaskItem.swift
//  sweety_bird
//
//  Created by Raphael Spencer on 1/28/19.
//  Copyright © 2019 Raphael Spencer. All rights reserved.
//

import Cocoa

class TaskItem: NSCollectionViewItem {

  @IBOutlet weak var title_label: NSTextField!
  @IBOutlet weak var detail_label: NSTextField!
  @IBOutlet weak var created_label: NSTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
}
