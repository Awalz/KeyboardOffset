//
//  ViewController.swift
//  KeyboardScroll
//
//  Created by Andrew on 2017-04-10.
//  Copyright © 2017 Walzy. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var tableView             : UITableView!
    var textField             : UITextField!
    var currentKeyboardHeight : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField                 = UITextField()
        textField.backgroundColor = UIColor.gray
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(45.0)
        }
        
        tableView            = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(textField.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

}

extension ViewController : UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()

    }
}


extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.blue
        }
        return cell
    }
}

extension ViewController {
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        return keyboardRectangle.height
    }
    
    func getKeyboardAnimationDuration(_ notification: Notification) -> Double {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let keyBoardDuration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        return keyBoardDuration
    }
    
    func getKeyboardAnimationCurve(_ notification: Notification) -> NSNumber {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardCurve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        return keyboardCurve
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let keyboardHeight    = getKeyBoardHeight(notification)
        let animationDuration = getKeyboardAnimationDuration(notification)
        let animationCurve    = getKeyboardAnimationCurve(notification)
        
        let offset = max(currentKeyboardHeight, keyboardHeight)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: animationCurve.intValue)!)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        
        view.frame.origin.y = -offset
        
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(_ notification:Notification) {
        let animationDuration = getKeyboardAnimationDuration(notification)
        let animationCurve    = getKeyboardAnimationCurve(notification)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: animationCurve.intValue)!)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        view.frame.origin.y = 0.0


        UIView.commitAnimations()
    }
    
}

