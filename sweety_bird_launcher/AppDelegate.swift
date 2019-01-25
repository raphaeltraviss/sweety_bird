/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa

extension Notification.Name {
  static let close_launcher = Notification.Name("close_launcher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @objc func terminate() {
    print("Terminate application")
    NSApp.terminate(nil)
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let main_app_id = "com.raphaeltraviss.familiar"
    let apps = NSWorkspace.shared.runningApplications
    let main_is_running = apps.filter({ $0.bundleIdentifier == main_app_id }).count > 0
    
    // If the launcher is already running, exit.
    guard !main_is_running else { self.terminate(); return }

    // Listen for when the main application tells us to close.
    DistributedNotificationCenter.default().addObserver(
      self,
      selector: #selector(self.terminate),
      name: .close_launcher,
      object: main_app_id
    )
    
    // Get our current path, and navigate up and over, to get the parent app that we are
    // emebbed inside.
    let path = Bundle.main.bundlePath as NSString
    var components = path.pathComponents
    components.removeLast(3)
    components.append("MacOS")
    components.append("sweety_bird")
    
    let main_app_path = NSString.path(withComponents: components)
    
    // Launch familiar
    NSWorkspace.shared.launchApplication(main_app_path)
  }
}

