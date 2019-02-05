/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */



import Foundation

struct Task : Codable {
  var id: Int
  var uuid: String
  var title: String
  var dueAt: String
  var startAt: String
  var completedAt: String
}
