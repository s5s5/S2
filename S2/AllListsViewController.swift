//
//  AllListsViewController.swift
//  S2
//
//  Created by s5s5 on 15/6/21.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

  var lists: [Checklist]

  // 必要 构造函数 生成默认列表
  // 其中initWithCoder⽤用于从storyboard中加载视图控制器
  // initWithNib⽤用于从nib⽂文件中加载视图控制器
  // 而initWithStyle则⽤用于⼿手动创建视图控制器。
  required init(coder aDeCoder: NSCoder) {

    lists = [Checklist]()

    super.init(coder: aDeCoder)

    var list = Checklist(name: "Birthdays")
    lists.append(list)

    list = Checklist(name: "Groceries")
    lists.append(list)

    list = Checklist(name: "Cool Apps")
    lists.append(list)

    list = Checklist(name: "To Do")
    lists.append(list)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

  // 从数据源返回给定表格视图的行数
  override func tableView(tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }

  // 问一个CELL中插入一个特定的表观位置数据源。
  override func tableView(tableView: UITableView,
      cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "Cell"
    // dequeueReusableCellWithIdentifier 返回可重⽤用的cell
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: .Default,
          reuseIdentifier: cellIdentifier)
    }

    // 为row行数据添加所需的cell
    let checklist = lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton

    return cell
  }

  // 当⽤用户触碰表视图中的某⼀行时就会触发这个代理⽅方法segue 
  override func tableView(tableView: UITableView,
      didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let checklist = lists[indexPath.row]
    performSegueWithIdentifier("ShowChecklist", sender: checklist)
  }

  // 事情即将完成通知视图
  // 将Checklist对象放⼊入sender参数并没有将该对象传递给ChecklistViewController。这件⼯工作是 由prepareForSegue⽅方法完成的
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destinationViewController as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }

  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func listDetailViewController(controller: ListDetailViewController,
      didFinishAddingChecklist checklist: Checklist) {
    let newRowIndex = lists.count
    lists.append(checklist)

    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
  }

  func listDetailViewController(controller: ListDetailViewController,
      didFinishEditingChecklist checklist: Checklist) {
    if let index = find(lists, checklist) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        cell.textLabel!.text = checklist.name
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }

  override func tableView(tableView: UITableView,
      commitEditingStyle editingStyle: UITableViewCellEditingStyle,
      forRowAtIndexPath indexPath: NSIndexPath) {
    lists.removeAtIndex(indexPath.row)

    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }

  override func tableView(tableView: UITableView,
      accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
    let controller = navigationController.topViewController as! ListDetailViewController
    controller.delegate = self

    let checklist = lists[indexPath.row]
    controller.checklistToEdit = checklist
    presentViewController(navigationController, animated: true, completion: nil)
  }

}
