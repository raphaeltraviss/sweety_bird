/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa

class TaskList: NSViewController {
  
  // MARK: public API
  
  var tasks = [Task]() { didSet {
    coll_view.reloadData()
  }}
  
  
  // MARK: private API and obj-c helpers

  
  // MARK: UI outlets
  
  @IBOutlet weak var coll_view: NSCollectionView! { didSet {
    let id = NSUserInterfaceItemIdentifier(rawValue: "task_item")
    coll_view.register(TaskItem.self, forItemWithIdentifier: id)
  }}
}
