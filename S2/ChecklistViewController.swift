//
//  ViewController.swift
//  S2
//
//  Created by s5s5 on 15/5/26.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

  var checklist: Checklist!

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

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell

    let item = checklist.items[indexPath.row]

    configureTextForCell(cell, withChecklistItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)

    return cell
  }

  // 打勾方法
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    if let cell = tableView.cellForRowAtIndexPath(indexPath) {

      let item = checklist.items[indexPath.row]
      item.toggleChecked()

      configureCheckmarkForCell(cell, withChecklistItem: item)

    }

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  // 删除方法
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    checklist.items.removeAtIndex(indexPath.row)

    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }


  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel

    if item.checked {
      label.text = "✓"
    } else {
      label.text = "❍"
    }

    label.textColor = view.tintColor
  }

  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
//    label.text = "\(item.itemID): \(item.text)"
    
//    let labelDate = cell.viewWithTag(2000) as! UILabel
//    labelDate.text = "\(item.dueDate)"
  }

  // 点击取消方法
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  // 点击添加方法
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
  }

  // 点击编辑方法
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    if let index = find(checklist.items, item) {

      let indexPath = NSIndexPath(forRow: index, inSection: 0)

      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withChecklistItem: item)
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    if segue.identifier == "AddItem" {

      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController
      controller.delegate = self

    } else if segue.identifier == "EditItem" {

      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ItemDetailViewController

      controller.delegate = self

      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }

    }

  }
}

