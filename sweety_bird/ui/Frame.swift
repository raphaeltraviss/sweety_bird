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
  
  @IBOutlet weak var settings_button: NSButton!
  
  @IBOutlet weak var refresh_button: NSButton! { didSet {
    refresh_button.action = #selector(make_task_call)
  } }
  
  
  // MARK: private helper methods
  
  fileprivate lazy var formatter: DateFormatter = {
    var formatter = DateFormatter()
    formatter.dateFormat = "'Due on' MM/dd"
    return formatter
  }()
  
  func ui_time(_ date: Date) -> String {
    return formatter.string(from: date)
  }
  
  @objc func init_task_list() {
    task_list.tasks = [
      Task(id: 33, uuid: "asdf-asdf-asdf-asdf", title: "The first task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
      Task(id: 28, uuid: "qwer-qwer-qwer-qwer", title: "The second task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
      Task(id: 407, uuid: "zxcv-zxcv-zxcv-zxcv", title: "The third task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
      Task(id: 68, uuid: "fghj-fghj-fghj-fghj", title: "The fourth task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
      Task(id: 465, uuid: "vbnm-vbnm-vbnm-bvnm", title: "The fifth task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
      Task(id: 98, uuid: "rtyu-rtyu-rtyu-rtyu", title: "The sixth task", dueAt: ui_time(1.days_ago()), startAt: ui_time(Date()), completedAt: ui_time(Date())),
    ]
  }
  
  struct TaskResponse : Codable {
    var data: TaskContainer
    
    struct TaskContainer: Codable {
      var tasks: [Task]
    }
  }
  
  
  @objc func make_task_call() {
    // Serialize the graphql query into a string
    guard let url = URL(string: "http://localhost:4000/graph") else { return }
    var request = URLRequest(url: url)
    
    request.addValue("application/json", forHTTPHeaderField: "content-type")
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("Bearer SFMyNTY.g3QAAAACZAAEZGF0YW0AAAAkZmIxZmYyZDEtY2Q3OS00ZGE1LTlhYTQtNGZkZjg3NTVlOWU2ZAAGc2lnbmVkbgYAZAxRSWkB.3Re5FgRaZgmG7ILt21pi5A3SGGHEwp9EmXsnTSyBfMc", forHTTPHeaderField: "authorization")
    
    request.httpMethod = "POST"
    let query: [String:Any] = ["query": "{ tasks { id uuid title completedAt dueAt startAt } }"]
    guard let postData = try? JSONSerialization.data(withJSONObject: query, options: []) else { return }
    guard let debug = String(bytes: postData, encoding: .utf8) else { return }
    request.httpBody = postData as Data
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      guard error == nil else { return }
      guard let d = data else { return }
      
      //  @TODO: use JSONEncoder instead of doing it manually.
      guard let json = try? JSONSerialization.jsonObject(with: d, options: []) else { return }
      guard let json_results = json as? [String: Any] else { return }
      guard let json_data = json_results["data"] as? [String: Any] else { return }
      guard let task_data = json_data["tasks"] as? [[String: Any]] else { return }
      let the_tasks = task_data.shuffled().prefix(10).map({ (task_data) -> Task? in
        guard let id = task_data["id"] as? String else { return nil }
        guard let uuid = task_data["uuid"] as? String else { return nil }
        let title = task_data["title"] as? String
        let dueAt = task_data["dueAt"] as? String
        let completedAt = task_data["completedAt"] as? String
        let startAt = task_data["startAt"] as? String
        return Task(
          id: Int(id)!,
          uuid: uuid,
          title: title ?? "something",
          dueAt: completedAt ?? "yet to be completed",
          startAt: startAt ?? "start date",
          completedAt: completedAt ?? "completed date"
        )
      })
      DispatchQueue.main.async {
        self.task_list.tasks = the_tasks.compactMap({ $0 })
      }
      
    })
    
    dataTask.resume()
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
