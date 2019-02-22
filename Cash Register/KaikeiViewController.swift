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
    @IBOutlet var Oazukari: UILabel!
    @IBOutlet var Oturi: UILabel!
    @IBOutlet var enone : UILabel!
    @IBOutlet var entwo: UILabel!
    //合計金額を入れる変数
    var total: Int = 0
    //お預かり金額のTextField
    @IBOutlet var custody: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.rowHeight = UIScreen.main.bounds.size.width / 8
        table.tableFooterView = UIView() //TableViewの空白cellの線を消す
        
        table.dataSource = self
        custody.delegate = self
        
        self.table.register(UINib(nibName: "BoughtTableViewCell", bundle: nil), forCellReuseIdentifier: "BoughtCell")
        
        for i in 0...(BoughtNameArray.count - 1) { //買った商品の数分の回数
           total += BoughtPriceArray[i] * BoughtCountArray[i] //合計金額に買った商品のね金額を足す
        }
        
        //お預かり入力を数字だけに
        custody.keyboardType = UIKeyboardType.numberPad
        configureObserver()  //Notification発行
        let DoneView = UIView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width ,height:UIScreen.main.bounds.size.width / 10))
        DoneView.backgroundColor = UIColor.white
        let done = UIButton(frame: CGRect(x: DoneView.frame.size.width - DoneView.frame.size.height * 2, y: 0, width: DoneView.frame.size.height * 2, height: DoneView.frame.size.height))
        done.setTitle("完了", for: UIControl.State.normal)
        done.addTarget(self,
                       action: #selector(KaikeiViewController.done(sender:)),
                       for: .touchUpInside)
        done.titleLabel?.font =  UIFont(name: "HiraginoSans-W3", size: done.frame.size.height * 0.5)
        done.setTitleColor(UIColor(red: 238 / 255, green: 195 / 255, blue: 85 / 255, alpha: 1), for: UIControl.State.normal)
        DoneView.addSubview(done)
        custody.inputAccessoryView = DoneView
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Oazukari.font = UIFont(name: "HiraginoSans-W3", size: Oazukari.frame.size.width / 4)
        Oturi.font = UIFont(name: "HiraginoSans-W3", size: Oazukari.frame.size.width / 4)
        custody.font = UIFont(name: "HiraginoSans-W3", size: Oazukari.frame.size.width / 4)
        ChangeLabel.font = UIFont(name: "HiraginoSans-W3", size: Oazukari.frame.size.width / 4)
        enone.font = UIFont(name: "HiraginoSans-W3", size: enone.frame.size.width)
        entwo.font = UIFont(name: "HiraginoSans-W3", size: enone.frame.size.width)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoughtNameArray.count //セルの数は買った商品の数
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "BoughtCell") as! BoughtTableViewCell //cellを作成
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
    
    //TableViewのフッターに合計金額を表示
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " 計 ￥\(total)"
    }
    
    //キーボード以外のところをタッチした時、キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reconing()
    }

    @objc func done(sender : AnyObject) {
        self.reconing()
    }
    
    func reconing() {
        self.custody.endEditing(true) //キーボードを閉じる
        if custody.text != String() { //お預かり金額が入力されている時
        if Int(custody.text!)! < total { //お預かり金額がお支払い金額より少ない時
            
            //alertを表示
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "お支払金額が不足しています", preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title:"OK",
                    style: .default,
                    handler: { action in
                        
                }
            ))
            present(alert, animated: true, completion: nil)
            
            ChangeLabel.text = String() //お釣りのlabelを白紙に
            
        } else {
            ChangeLabel.text = String(Int(custody.text!)! - total) //お釣りを表示する
        }
        } else {
            ChangeLabel.text = String() //お釣りのlabelを白紙に
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
