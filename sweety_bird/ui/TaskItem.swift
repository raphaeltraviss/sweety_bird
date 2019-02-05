/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Cocoa

class TaskItem: NSCollectionViewItem {

  @IBOutlet weak var title_label: NSTextField! { didSet {
    title_label.isBezeled = false
    title_label.drawsBackground = false
    title_label.isEditable = false
    title_label.wantsLayer = true
    title_label.layer?.backgroundColor = NSColor.clear.cgColor
    }}
  @IBOutlet weak var detail_label: NSTextField!
  @IBOutlet weak var created_label: NSTextField!
  
  override func viewDidLoad() {
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor(calibratedRed: 0.90, green: 0.90, blue: 0.90, alpha: 1.0).cgColor
  }
}
