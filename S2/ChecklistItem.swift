//
//  ChecklistItem.swift
//  S2
//
//  Created by s5s5 on 15/6/2.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false

  func toggleChecked() {
    checked = !checked
  }

  // 写入归档方法
  func encodeWithCoder(aCoder: NSCoder) {
    // 编码归档文件
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
  }

  // 初始化读取归档方法
  required init(coder aDecoder: NSCoder) {
    // 解码归档文件
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    super.init()
  }

  // 初始化
  override init() {
    super.init()
  }
}
