//
//  IconPickerViewController.swift
//  S2
//
//  Created by s5s5 on 15/7/31.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
  weak var delegate: IconPickerViewControllerDelegate?

  let icons = ["Appointments", "Baby", "Band", "Birthdays", "Call", "Chores", "Drinks", "Folder", "Games", "Groceries", "Index", "Medicine", "Meeting", "Money", "Party", "Pet", "Photos", "Read", "Shopping", "Sports", "Stargazing", "Trips", "TV Show", "View Spot", "Work Out"]

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as UITableViewCell?
    let iconName = icons[indexPath.row]
    cell!.textLabel!.text = iconName
    cell!.imageView!.image = UIImage(named: iconName)

    return cell!
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let delegate = delegate {
      let iconName = icons[indexPath.row]
      delegate.iconPicker(self, didPickIcon: iconName)
    }
  }
}
