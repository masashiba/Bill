//
//  ShouhinTourokuViewController.swift
//  Cash Register
//
//  Created by 芝本　将豊 on 2018/11/09.
//  Copyright © 2018 芝本　将豊. All rights reserved.
//

import UIKit

class ShouhinTourokuViewController: UIViewController, UITextFieldDelegate {
    
    //商品の情報入力部分の宣言
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    @IBOutlet var Shouhinmei: UILabel!
    @IBOutlet var Kingaku: UILabel!
    @IBOutlet var en: UILabel!
    
    //商品情報の配列の宣言
    var NameArray = [String]()
    var PriceArray = [Int]()
    
    var saveDate: UserDefaults = UserDefaults.standard //UserDefaultsの宣言
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Shouhinmei.font = UIFont(name: "HiraginoSans-W3", size: Shouhinmei.frame.size.height)
        Kingaku.font = UIFont(name: "HiraginoSans-W3", size: Shouhinmei.frame.size.height)
        NameTextField.font = UIFont(name: "HiraginoSans-W3", size: Shouhinmei.frame.size.height)
        PriceTextField.font = UIFont(name: "HiraginoSans-W3", size: Shouhinmei.frame.size.height)
        en.font = UIFont(name: "HiraginoSans-W3", size: en.frame.size.width)
    }
    
    override func viewWillAppear(_ animated: Bool) { //viewが表示された時
        
        NameTextField.delegate = self
        
        //UserDefaultsに配列がある場合のみ（一個も商品登録をしていない時への配慮）、その配列を取り出す
        if saveDate.array(forKey: "NameArray") != nil {
            NameArray = saveDate.array(forKey: "NameArray") as! [String]
        }
        if saveDate.array(forKey: "PriceArray") != nil {
            PriceArray = saveDate.array(forKey: "PriceArray") as! [Int]
        }
        
        PriceTextField.keyboardType = UIKeyboardType.numberPad //値段の入力キーボードを数字だけに
    }
    
    //キーボード以外のところをタッチした時、キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.NameTextField.endEditing(true)
        self.PriceTextField.endEditing(true)
    }
    
    //登録ボタンを押した時
    @IBAction func Registration() {
        
        //商品名も金額も入力されている時
        if NameTextField.text != "" && PriceTextField.text != "" {
            
            if NameArray.contains(NameTextField.text!) {
                let alert: UIAlertController = UIAlertController(title: "エラー", message: "この商品はすでに登録されています", preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(
                        title:"OK",
                        style: .default,
                        handler: { action in
                            
                    }
                ))
                present(alert, animated: true, completion: nil)
            } else {
                //入力された情報を配列に追加
                NameArray.append(NameTextField.text!)
                PriceArray.append(Int(PriceTextField.text!)!)
                
                //画面遷移
                performSegue(withIdentifier: "Touroku", sender: nil)
            }
            
        } else {
            
            //入力されていない時、アラートを表示
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "入力していない情報があります", preferredStyle: .alert)
            
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
    
    //登録して画面遷移する時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Touroku" {
            
            //UserDefaultsに配列を保存
            saveDate.set(NameArray, forKey: "NameArray")
            saveDate.set(PriceArray, forKey: "PriceArray")
            
            //値(UserDefaults)の受け渡し
            let kaimonoViewController = segue.destination as! KaimonoViewController
            kaimonoViewController.saveDate = self.saveDate
            
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
