//
//  ChecklistItem.swift
//  S2
//
//  Created by s5s5 on 15/6/2.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
  var text = ""
  var checked = false

  func toggleChecked() {
    checked = !checked
  }
}
