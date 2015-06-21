//
//  ViewController.swift
//  S2
//
//  Created by s5s5 on 15/5/26.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {

  var items: [ChecklistItem]
  var checklist: Checklist!

  required init(coder aDecoder: NSCoder) {
    items = [ChecklistItem]()
    // 初始化
    super.init(coder: aDecoder)
    loadChecklistItems()
  }

  // 加载数据
  func loadChecklistItems() {
    let path = dataFilePath()

    // 如果PLIST存在
    if NSFileManager.defaultManager().fileExistsAtPath(path) {

      // 读取
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        items = unarchiver.decodeObjectForKey("ChecklistItems")
        as! [ChecklistItem]
        unarchiver.finishDecoding()
      }
    }
  }

  override func tableView(tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(tableView: UITableView,
      cellForRowAtIndexPath indexPath: NSIndexPath)
          -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
               as! UITableViewCell

    let item = items[indexPath.row]

    configureTextForCell(cell, withChecklistItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)

    return cell
  }

  // 打勾方法
  override func tableView(tableView: UITableView,
      didSelectRowAtIndexPath indexPath: NSIndexPath) {

    if let cell = tableView.cellForRowAtIndexPath(indexPath) {

      let item = items[indexPath.row]
      item.toggleChecked()

      configureCheckmarkForCell(cell, withChecklistItem: item)

    }

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  // 删除方法
  override func tableView(tableView: UITableView,
      commitEditingStyle editingStyle: UITableViewCellEditingStyle,
      forRowAtIndexPath indexPath: NSIndexPath) {

    items.removeAtIndex(indexPath.row)

    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    saveChecklistItems()
  }

  // VIEW加载时方法
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    //不同的checklist时会显⽰示不同的标题
    title = checklist.name
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func configureCheckmarkForCell(cell: UITableViewCell,
      withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel

    if item.checked {
      label.text = "✓"
    } else {
      label.text = ""
    }
  }

  func configureTextForCell(cell: UITableViewCell,
      withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }

  override func prepareForSegue(segue: UIStoryboardSegue,
      sender: AnyObject?) {

    if segue.identifier == "AddItem" {

      let navigationController = segue.destinationViewController
                                 as! UINavigationController
      let controller = navigationController.topViewController
                       as! ItemDetailViewController
      controller.delegate = self

    } else if segue.identifier == "EditItem" {

      let navigationController = segue.destinationViewController
                                 as! UINavigationController
      let controller = navigationController.topViewController
                       as! ItemDetailViewController

      controller.delegate = self

      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }

    }

  }

  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  // 点击添加方法
  func itemDetailViewController(controller: ItemDetailViewController,
      didFinishAddingItem item: ChecklistItem) {
    let newRowIndex = items.count
    items.append(item)
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths,
        withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }

  // 点击编辑方法
  func itemDetailViewController(controller: ItemDetailViewController,
      didFinishEditingItem item: ChecklistItem) {
    if let index = find(items, item) {

      let indexPath = NSIndexPath(forRow: index, inSection: 0)

      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withChecklistItem: item)
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }

  // 获取沙盒路径
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(
                .DocumentDirectory, .UserDomainMask, true) as! [String]
    return paths[0]
  }

  // 获取PLIST文件
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent(
    "Checklists.plist")
  }

  // 写⼊PLIST文件
  func saveChecklistItems() {
    let data = NSMutableData()
    // NSKeyedArchiver 对数组进⾏行编码
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }

}

