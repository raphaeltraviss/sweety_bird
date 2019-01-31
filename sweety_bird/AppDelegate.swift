/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Cocoa
import ServiceManagement

typealias MessageAction = (String) -> Void

extension Notification.Name {
  static let close_launcher = Notification.Name("close_launcher")
}

let launcher_app_id = "com.raphaeltraviss.sweety_bird_launcher"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system.statusItem(withLength: 28.0)
  let task_list = TaskList.instance_from_sb()
  

  var system_delegate: WorkspaceDelegate?
  let popover = NSPopover()
  var click_detector: Any?
  var launcher_is_running = false
  var login_menu_item: NSMenuItem?
  var will_launch_at_login: Bool = true {
    didSet {
      self.update_menu_ui()
    }
  }
  
  func check_and_close_launcher() {
    // If the launcher is running, then it must have started at login.
    let apps = NSWorkspace.shared.runningApplications
    self.launcher_is_running = apps.filter { $0.bundleIdentifier == launcher_app_id }.count > 0
    
    // Start our launcher app at login
    SMLoginItemSetEnabled(launcher_app_id as CFString, true)
    
    // If WE are running, and the launcher is running, then we don't need it any more.
    guard self.launcher_is_running else { return }
    
    DistributedNotificationCenter.default().postNotificationName(
      .close_launcher,
      object: Bundle.main.bundleIdentifier,
      userInfo: nil,
      options: DistributedNotificationCenter.Options.deliverImmediately
    )
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    //check_and_close_launcher()
    
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("birdseye_menubar"))
      button.action = #selector(showPopover)
    }
    
    
//    self.login_menu_item = NSMenuItem(title: "Start at login", action: #selector(self.toggle_login_start), keyEquivalent: "l")
    let launch_enabled = UserDefaults.standard.bool(forKey: "will_launch_at_login")
//    self.login_menu_item!.state = launch_enabled ? .on : .off
    
    
//    let menu = NSMenu()
//    menu.addItem(NSMenuItem(title: "Another option (quit, right now)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "1"))
//    menu.addItem(NSMenuItem.separator())
//    menu.addItem(self.login_menu_item!)
//    menu.addItem(NSMenuItem(title: "Quit sweety_bird", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
//
//    statusItem.menu = menu

    popover.contentSize = NSSize(width: 340.0, height: 640.0)
    popover.contentViewController = task_list
    task_list.tasks = [
      Task(title: "task 1", detail: "The first task", created_at: Date()),
      Task(title: "task 2", detail: "The second task", created_at: Date()),
      Task(title: "task 3", detail: "The third task", created_at: Date()),
      Task(title: "task 4", detail: "The fourth task", created_at: Date()),
      Task(title: "task 5", detail: "The fifth task", created_at: Date()),
      Task(title: "task 6", detail: "The sixth task", created_at: Date()),
      Task(title: "task 7", detail: "The seventh task", created_at: Date()),
      Task(title: "task 8", detail: "The eigth task", created_at: Date()),
    ]
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
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
    guard let menu_item = self.login_menu_item else { return }
    // Update the UI state of the button to reflect application state.
    menu_item.state = self.will_launch_at_login ? .on : .off
  }
  
  @objc func toggle_login_start() {
    // Mutate our own state to be the opposite of the current state.
    self.will_launch_at_login = !self.will_launch_at_login
    
    // Set login item status according to the will_login state.
    SMLoginItemSetEnabled(launcher_app_id as CFString, will_launch_at_login)
    
    // Save the login item state to user defaults, so our UI will reflect the SMLogin status
    // when the app is re-launched.
    UserDefaults.standard.set(self.will_launch_at_login, forKey: "will_launch_at_login")
  }
  
  func closePopover(sender: Any?) {
    popover.performClose(sender)
  }
}


