/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa
import ServiceManagement

typealias MessageAction = (String) -> Void
let launcher_app_id = "com.raphaeltraviss.sweety_bird_launcher"


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  let statusItem = NSStatusBar.system.statusItem(withLength: 28.0)
  let app_frame = Frame.instance_from_sb()
  
  let popover = NSPopover()
  var click_detector: Any?
  var launcher_is_running = false
  var login_menu_item: NSMenuItem?
  var will_launch_at_login: Bool = true {
    didSet { self.update_menu_ui() }
  }
  
  func check_and_close_launcher() {
    // If the launcher is running, then it must have started at login.
    let apps = NSWorkspace.shared.runningApplications
    self.launcher_is_running = apps.filter { $0.bundleIdentifier == launcher_app_id }.count > 0
    
    // Start our launcher app at login
    SMLoginItemSetEnabled(launcher_app_id as CFString, true)
    
    // If WE are running, and the launcher is running, then we don't need it any more.
    guard self.launcher_is_running else { return }
    
    // Send a close_launcher message to all processes that are listening.
    DistributedNotificationCenter.default().postNotificationName(
      .close_launcher,
      object: Bundle.main.bundleIdentifier,
      userInfo: nil,
      options: DistributedNotificationCenter.Options.deliverImmediately
    )
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    check_and_close_launcher()
    
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("birdseye_menubar"))
      button.action = #selector(showPopover)
    }
    
    let launch_enabled = UserDefaults.standard.bool(forKey: "will_launch_at_login")

    popover.contentSize = NSSize(width: 340.0, height: 640.0)
    popover.contentViewController = app_frame
  }
  
  func hidePopover() {
    popover.performClose(nil)
    guard let the_detector: Any = self.click_detector else { return }
    NSEvent.removeMonitor(the_detector)
    self.click_detector = nil
  }
  
  // Create a listener to close the popover when the user clicks.
  @objc func showPopover(sender: Any?) {
    guard let button = statusItem.button else { return }
    guard self.click_detector == nil else { return }
    
    popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    self.click_detector = NSEvent.addGlobalMonitorForEvents(matching:[NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown], handler: { [weak self] event in
      self?.hidePopover()
    })
  }
  
  
  func update_menu_ui() {
    print("UI update triggered")
  }
  
  @objc func toggle_login_start() {
    self.will_launch_at_login = !self.will_launch_at_login
    SMLoginItemSetEnabled(launcher_app_id as CFString, will_launch_at_login)
    UserDefaults.standard.set(self.will_launch_at_login, forKey: "will_launch_at_login")
  }
}


extension Int {
  func days_ago() -> Date {
    return Calendar.current.date(byAdding: .day, value: self, to: Date())!
  }
}

extension Notification.Name {
  static let close_launcher = Notification.Name("close_launcher")
}
