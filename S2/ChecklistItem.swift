//
//  ChecklistItem.swift
//  S2
//
//  Created by s5s5 on 15/6/2.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import Foundation
import UIKit

// 遵从NSCoding协议

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int

  func toggleChecked() {
    checked = !checked
  }

  // 初始化
  override init() {
    itemID = DataModel.nextChecklistItemID()
    super.init()
  }



  // 初始化读取归档方法
  // 从NSCoder的 decoder对象中取出了对象,然后将值保存在ChecklistItem的属性中
  required init(coder aDecoder: NSCoder) {
    // 解码归档文件
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
    shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
    itemID = aDecoder.decodeIntegerForKey("ItemID")
    super.init()
  }

  // 写入归档方法
  // 当NSKeyedArchiver尝试对 某个ChecklistItem对象编码时,就会发送encodeWithCoder消息
  func encodeWithCoder(aCoder: NSCoder) {
    // 编码归档文件
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
    aCoder.encodeObject(dueDate, forKey: "DueDate")
    aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
    aCoder.encodeInteger(itemID, forKey: "ItemID")
  }
  
  func scheduleNotification() {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      println("Found an existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
    
    if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
      let localNotification = UILocalNotification()
      localNotification.fireDate = dueDate
      localNotification.timeZone = NSTimeZone.defaultTimeZone()
      localNotification.alertBody = text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID": itemID]
      
      UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
      
      println("Scheduled notification \(localNotification) for itemID \(itemID)")
    }
  }
  
  func notificationForThisItem() -> UILocalNotification? {
    let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]
    for notification in allNotifications {
      if let number = notification.userInfo?["ItemID"] as? NSNumber {
        if number.integerValue == itemID {
          return notification
        }
      }
    }
    return nil
  }
  
  deinit {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      println("Removing existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  }
}
