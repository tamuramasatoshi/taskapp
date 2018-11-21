//
//  InputViewController.swift
//  taskapp
//
//  Created by 田村尚利 on 2018/11/09.
//  Copyright © 2018 masatoshi.tamura. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contensTextView: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var category: UITextField!
    
    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する。
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(dimssKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contensTextView.text = task.contents
        datePicker.date = task.date
        category.text = task.category
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contensTextView.text!
            self.task.date = self.datePicker.date
            self.task.category = category.text!
            
            self.realm.add(self.task, update: true)
          
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    //タスクのローカル通知を登録する
    
    func setNotification(task: Task){
        let content = UNMutableNotificationContent()
        
        //タイトルと同じ内容を設定（中身がない場合メッセージ無しで音だけの通知になるので「（××なし）」を表示する）
        if task.title == ""{
            content.title = "(タイトルなし）"
        } else {
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "(内容なし）"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        
        //ローカル通知が発動するtrigger(日付けマッチ）作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録　OK") //errorかnil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        //未知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests{
                print("/-------------")
                print(request)
                print("-------------/")
            }
        }
    }
    
    @objc func dimssKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
        
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


