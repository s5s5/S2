//
//  DataModel.swift
//  S2
//
//  Created by s5s5 on 15/7/27.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()

  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }

  // 获取PLIST文件夹路径
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]

    return paths[0]
  }

  // 获取PLIST文件路径
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
  }

  // save to plist
  func saveChecklists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(lists, forKey: "Checklists")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }

  // load form plist
  func loadChecklists() {
    let path = dataFilePath()
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
        unarchiver.finishDecoding()

        sortChecklists()
      }
    }
  }

  // first open
  func registerDefaults() {
    let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "ChecklisItemID": 0]

    NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
  }

  var indexOfSelectedChecklist: Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
    }
    set {
      NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
//      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }

  func handleFirstTime() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let firstTime = userDefaults.boolForKey("FirstTime")
    if firstTime {
      let checklist = Checklist(name: "🎉🍺🔞👯Ｐarty")
      lists.append(checklist)
      indexOfSelectedChecklist = 0
      userDefaults.setBool(false, forKey: "FirstTime")
    }
  }

  func sortChecklists() {
    lists.sort({ checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending })
  }

  class func nextChecklistItemID() -> Int {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let itemID = userDefaults.integerForKey("ChecklistItemID")
    userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}
