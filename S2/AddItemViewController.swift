//
//  AddItemViewController.swift
//  S2
//
//  Created by s5s5 on 15/6/3.
//  Copyright (c) 2015年 misuisui. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!

  @IBAction func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func done() {
    println("Contents of the text field: \(textField.text)")
    dismissViewControllerAnimated(true, completion: nil)
  }

  override func tableView(tableView: UITableView,
                          willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

  func textField(textField: UITextField,
                 shouldChangeCharactersInRange range: NSRange,
                 replacementString string: String) -> Bool {

    let oldText: NSString = textField.text
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)

    doneBarButton.enabled = (newText.length > 0)

    return true
  }

}
