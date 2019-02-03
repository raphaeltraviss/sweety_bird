/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Foundation
import AppKit

class WorkspaceDelegate {
  let tasks: [Int]
    
  init(tasks: [Int]) {
    self.tasks = tasks
    NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(fetch_task_deltas), name: NSWorkspace.didWakeNotification, object: nil)
  }
  
  @objc func fetch_task_deltas() {
    for task in tasks {
      print("I've just woken up!")
    }
  }
}
