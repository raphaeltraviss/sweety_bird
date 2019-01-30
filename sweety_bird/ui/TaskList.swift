/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa

class TaskList: NSViewController {
  
  // MARK: public API
  
  var tasks = [Task]() { didSet {
    guard let coll_ui = coll_view else { return }
    coll_ui.reloadData()
  }}
  
  // MARK: private API and obj-c helpers

  
  // MARK: UI outlets
  
  @IBOutlet weak var coll_view: NSCollectionView! { didSet {
    let id = NSUserInterfaceItemIdentifier(rawValue: "task_item")
    coll_view.register(TaskItem.self, forItemWithIdentifier: id)
  }}
}

extension TaskList {
  static func instance_from_sb() -> TaskList {
    let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let id = NSStoryboard.SceneIdentifier(rawValue: "TaskList")
    guard let vc = sb.instantiateController(withIdentifier: id) as? TaskList else {
      fatalError("GWARRRR!!  WHERE DAT VIEW CONTROLLER!!??? - Check Main.storyboard")
    }
    return vc
  }
}
