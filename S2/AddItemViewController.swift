//
//  AddItemViewController.swift
//  S2
//
//  Created by s5s5 on 15/6/3.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

  @IBAction func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func done() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func tableView(tableView: UITableView,
    willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      return nil
  }

}
