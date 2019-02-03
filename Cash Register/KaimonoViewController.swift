//
//  KaimonoViewController.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/11/09.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class KaimonoViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet var table : UITableView! //商品を並べるTableViewの宣言
    
    //商品情報を入れる配列の宣言
    var NameArray = [String]()
    var PriceArray = [Int]()
    //買った商品の情報をお会計の画面に渡すための配列
    var BoughtNameArray = [String]()
    var BoughtPriceArray = [Int]()
    var BoughtCountArray = [Int]()
    
    var CellArray = [CustomTableViewCell]() //CustomCellを入れるための配列
    
    var saveDate : UserDefaults = UserDefaults.standard //商品情報を受け取るためのUserDefaultsの宣言

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.tableFooterView = UIView()//TableViewの空白cellの線を消す
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) { //viewが表示されたとき
        
        table.dataSource = self
        
        print(NameArray)
        print(PriceArray)
        
        //CustomCellを呼び出せる状態にする
        self.table.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        //UserDefaultsに配列がある場合のみ（一個も商品登録をしていない時への配慮）、その配列を取り出す
        if saveDate.array(forKey: "NameArray") != nil {
            NameArray = saveDate.array(forKey: "NameArray") as! [String]
        }
        if saveDate.array(forKey: "PriceArray") != nil {
            PriceArray = saveDate.array(forKey: "PriceArray") as! [Int]
        }
        
        if NameArray.count > 0 {
            
            CellArray = [CustomTableViewCell]()  //CellArrayの中身をリセット（空にする）
            
            for i in 0...NameArray.count - 1 { //cellの数だけ
                
                let cell = table.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell //商品情報をのせるセルを作る
                
                //セルに商品情報をのせる
                cell.NameLabel.text = NameArray[i]
                cell.PriceLabel.text = "￥" + String(PriceArray[i])
                
                CellArray.append(cell) //作ったセルを配列に入れる
                
            }
            
        }
        
        table.reloadData() //TableViewを更新
        print(NameArray)
        print(PriceArray)
    }
    
    //商品登録した後segueでこの画面に戻ってくるメソッド
    @IBAction func Touroku(segue: UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //セルの数は
        return CellArray.count //配列の数
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CellArray[indexPath.row] //CellArrayに入っているセルを上から順番に代入していく
    }
    
    //セルを削除＆配列内からそのデータも削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "「\(NameArray[indexPath.row])」を削除しますか？", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title:"削除",
                style: .destructive,
                handler: { action in
                    self.NameArray.remove(at: indexPath.row)
                    self.PriceArray.remove(at: indexPath.row)
                    self.CellArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    
                    //UserDefaultsに配列を保存
                    self.saveDate.set(self.NameArray, forKey: "NameArray")
                    self.saveDate.set(self.PriceArray, forKey: "PriceArray")
            }
        ))
        
        alert.addAction(
            UIAlertAction(
                title:"キャンセル",
                style: .cancel,
                handler: { action in
                    
            }
        ))
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func Kaikei() {
        
        if CellArray.count > 0 {
        
        for i in 0...(CellArray.count - 1) {
            
            //商品が買われていたら
            if Int(CellArray[i].stepper.value) != 0 {
                
                //買った商品の配列に商品情報を格納
                BoughtNameArray.append(NameArray[i])
                BoughtPriceArray.append(PriceArray[i])
                BoughtCountArray.append(Int(CellArray[i].stepper.value))
                
            }
        }
            if BoughtNameArray.count != 0 {
                
                performSegue(withIdentifier: "ToKaikei", sender: nil)
                
                BoughtNameArray = [String]()
                BoughtCountArray = [Int]()
                BoughtPriceArray = [Int]()
                
            } else {
                //商品を一個も買っていない時、アラートを表示
                let alert: UIAlertController = UIAlertController(title: "エラー", message: "商品を購入していません", preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(
                        title:"OK",
                        style: .default,
                        handler: { action in
                            
                    }
                ))
                present(alert, animated: true, completion: nil)
            }
        } else {
            //商品を登録していない時、アラートを表示
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "商品を登録していません", preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title:"OK",
                    style: .default,
                    handler: { action in
                        
                }
            ))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToTouroku" {
            //UserDefaultsに配列を保存
            saveDate.set(NameArray, forKey: "NameArray")
            saveDate.set(PriceArray, forKey: "PriceArray")
            //値(UserDefaults)の受け渡し
            let shouhintourokuViewController = segue.destination as! ShouhinTourokuViewController
            shouhintourokuViewController.saveDate = self.saveDate
            
        }
        
        if segue.identifier == "ToKaikei" {
            //買った商品情報の受け渡し
            let kaikeiViewController = segue.destination as! KaikeiViewController
            kaikeiViewController.BoughtNameArray = self.BoughtNameArray
            kaikeiViewController.BoughtPriceArray = self.BoughtPriceArray
            kaikeiViewController.BoughtCountArray = self.BoughtCountArray
            
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
