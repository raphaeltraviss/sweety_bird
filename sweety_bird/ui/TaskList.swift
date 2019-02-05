/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa

class TaskList: NSViewController {
  
  // MARK: constants
  let item_id = NSUserInterfaceItemIdentifier(rawValue: "task_item")
  
  // MARK: public API
  
  var tasks = [Task]() { didSet {
    guard let coll_ui = coll_view else { return }
    coll_ui.reloadData()
  }}

  
  // MARK: private API and obj-c helpers

  fileprivate lazy var formatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.dateFormat = "'Due on' MM/dd"
    return formatter
  }()
  
  func ui_time(_ date: Date) -> String {
    return formatter.string(from: date)
  }
  
  // MARK: UI outlets
  
  @IBOutlet weak var coll_view: NSCollectionView! { didSet {
    coll_view.register(TaskItem.self, forItemWithIdentifier: item_id)
    coll_view.dataSource = self
  }}
  
  // MARK: lifecycle
  
  
}

extension TaskList: NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let task = tasks[indexPath.item]
    guard let item = coll_view.makeItem(withIdentifier: item_id, for: indexPath) as? TaskItem else { fatalError() }
    item.title_label.stringValue = task.title
    item.detail_label.stringValue = task.detail
    item.created_label.stringValue = ui_time(task.created_at)
    return item
  }
  
  
}
