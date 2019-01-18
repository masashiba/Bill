//
//  KaikeiViewController.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/11/09.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class KaikeiViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate {

    //買った商品の情報を受け取るための配列
    var BoughtNameArray = [String]()
    var BoughtPriceArray = [Int]()
    var BoughtCountArray = [Int]()
    //買った商品の情報をのせるTableView
    @IBOutlet var table: UITableView!
    //お釣りを表示するlabel
    @IBOutlet var ChangeLabel: UILabel!
    //合計金額を入れる変数
    var total: Int = 0
    //お預かり金額のTextField
    @IBOutlet var custody: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TableViewの空白cellの線を消す
        table.tableFooterView = UIView()
        
        table.dataSource = self
        custody.delegate = self
        
        self.table.register(UINib(nibName: "BoughtTableViewCell", bundle: nil), forCellReuseIdentifier: "BoughtCell")
        
        for i in 0...(BoughtNameArray.count - 1) {
           total += BoughtPriceArray[i] * BoughtCountArray[i]
        }
        
        //お預かり入力を数字だけに
        custody.keyboardType = UIKeyboardType.numberPad
        configureObserver()  //Notification発行
        let DoneView = UIView(frame: CGRect(x:0,y:0,width:320,height:40))
        DoneView.backgroundColor = UIColor.black
        let done = UIButton(frame: CGRect(x:0,y:0,width:40,height:25))
        done.setTitle("完了", for: UIControl.State.normal)
        done.addTarget(self,
                       action: #selector(KaikeiViewController.done(sender:)),
                       for: .touchUpInside)
        done.titleLabel?.font =  UIFont.systemFont(ofSize: 18)
        DoneView.addSubview(done)
        custody.inputAccessoryView = DoneView
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セルの数は買った商品の数
        return BoughtNameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellを作成
        let cell = table.dequeueReusableCell(withIdentifier: "BoughtCell") as! BoughtTableViewCell
        //cellに買った商品の情報をのせる
        cell.NameLabel.text = "\(BoughtNameArray[indexPath.row])(￥\(BoughtPriceArray[indexPath.row]))"
        cell.CountLabel.text = "\(BoughtCountArray[indexPath.row])個"
        cell.PriceLabel.text = "￥\(BoughtPriceArray[indexPath.row] * BoughtCountArray[indexPath.row])"
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //買った商品の情報を初期化
        BoughtNameArray = [String]()
        BoughtCountArray = [Int]()
        BoughtPriceArray = [Int]()
        total = 0
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "計 ￥\(total)"
    }
    
    //キーボード以外のところをタッチした時、キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reconing()
    }

    @objc func done(sender : AnyObject) {
        self.reconing()
    }
    
    func reconing() {
        self.custody.endEditing(true)
        if custody.text != String() {
        if Int(custody.text!)! < total {
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "お支払金額が不足しています", preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title:"OK",
                    style: .default,
                    handler: { action in
                        
                }
            ))
            present(alert, animated: true, completion: nil)
            
            ChangeLabel.text = String()
            
        } else {
            ChangeLabel.text = String(Int(custody.text!)! - total)
        }
        } else {
            ChangeLabel.text = String()
        }
    }
    
    /// Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
    }
    
    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
