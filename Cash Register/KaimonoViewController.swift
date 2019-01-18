//
//  KaimonoViewController.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/11/09.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class KaimonoViewController: UIViewController,UITableViewDataSource {

    //商品情報を受け取るためのUserDefaultsの宣言
    var saveDate : UserDefaults = UserDefaults.standard
    
    //商品情報を入れる配列の宣言
    var NameArray = [String]()
    var PriceArray = [Int]()
    //買った商品の情報をお会計の画面に渡すための配列
    var BoughtNameArray = [String]()
    var BoughtPriceArray = [Int]()
    var BoughtCountArray = [Int]()
    //CustomCellを入れるための配列
    var CellArray = [CustomTableViewCell]()
    
    //商品を並べるTableViewの宣言
    @IBOutlet var table : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableViewの空白cellの線を消す
        table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        table.dataSource = self
        
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
            
            //CellArrayの中身をリセット（空にする）
            CellArray = [CustomTableViewCell]()
            
            //cellの数だけ
            for i in 0...NameArray.count - 1 {
                
                //CustomCellを作る
                let cell = table.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
                
                //CustomCellに商品の情報をのせる
                cell.NameLabel.text = NameArray[i]
                cell.PriceLabel.text = "￥" + String(PriceArray[i])
                
                //作ったセルを配列に入れる
                CellArray.append(cell)
                
            }
            
        }
        //TableViewを更新
        table.reloadData()
    }
    
    //商品登録した後segueでこの画面に戻ってくるメソッド
    @IBAction func Touroku(segue: UIStoryboardSegue) {
        
    }
    
    //セルの数は
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //配列の数
        return NameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //CellArrayに入っているセルを上から順番に代入していく
        return CellArray[indexPath.row]
        
    }
    
    //セルを削除＆配列内からそのデータも削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            NameArray.remove(at: indexPath.row)
            PriceArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        //UserDefaultsに配列を保存
        saveDate.set(NameArray, forKey: "NameArray")
        saveDate.set(PriceArray, forKey: "PriceArray")
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