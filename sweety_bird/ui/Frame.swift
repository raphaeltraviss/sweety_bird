//
//  Frame.swift
//  sweety_bird
//
//  Created by Raphael Spencer on 2/5/19.
//  Copyright © 2019 Raphael Spencer. All rights reserved.
//

import Cocoa

class Frame: NSViewController {
  // MARK: private outlets
  var task_list: TaskList!
  
  // MARK: private helper methods
  fileprivate func init_task_list() {
    task_list.tasks = [
      Task(title: "task 1", detail: "The first task", created_at: 1.days_ago()),
      Task(title: "task 2", detail: "The second task", created_at: 2.days_ago()),
      Task(title: "task 3", detail: "The third task", created_at: 3.days_ago()),
      Task(title: "task 4", detail: "The fourth task", created_at: 4.days_ago()),
      Task(title: "task 5", detail: "The fifth task", created_at: 5.days_ago()),
      Task(title: "task 6", detail: "The sixth task", created_at: 6.days_ago()),
      Task(title: "task 7", detail: "The seventh task", created_at: 7.days_ago()),
      Task(title: "task 8", detail: "The eigth task", created_at: 8.days_ago()),
    ]
  }
  
  // MARK: view controller lifecycle
  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    let the_list = segue.destinationController as! TaskList
    task_list = the_list
    init_task_list()
  }
}

extension Frame {
  static func instance_from_sb() -> Frame {
    let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let id = NSStoryboard.SceneIdentifier(rawValue: "Frame")
    guard let vc = sb.instantiateController(withIdentifier: id) as? Frame else {
      fatalError("GWARRRR!!  WHERE DAT VIEW CONTROLLER!!??? - Check Main.storyboard")
    }
    return vc
  }
}
