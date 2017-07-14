//
//  ViewController.swift
//  Sweet
//
//  Created by miho on 2017/06/21.
//  Copyright © 2017年 miho. All rights reserved.
//

import UIKit
import MediaPlayer
import Foundation
import CoreImage

class ViewController: UIViewController, MPMediaPickerControllerDelegate {

    var player = MPMusicPlayerController()
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var nowAlbum: UILabel!
    @IBOutlet weak var nowPlaying: UILabel!
    @IBOutlet weak var nowArtist: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var speakLabel: UILabel!
    
    //この値によってうさぎの色が変わる
    static var test = 0
    
    //うさぎの色の初期状態。最初は白
    static var usa = "うさしろ"
    
    static let sweets = ["chocolate", "cookie", "candy", "marshmallow", "cake", "pudding"]
    
    //これはクラス全体で使う（isHiddenをtrueにしたりfalseにしたりする）のでここに書いておく
    var replicatorLayer = CAReplicatorLayer()

    
    func circle() {
        // CAReplicatorLayerを生成、追加
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = view.bounds
        view.layer.addSublayer(replicatorLayer)
        
        // sourceになるSublayerを生成、追加
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: -20, width: 10, height: 10)
        circle.position = view.center
        circle.position.x -= 30
        circle.backgroundColor = UIColor.orange.cgColor
        circle.cornerRadius = 5
        replicatorLayer.addSublayer(circle)
        
        replicatorLayer.instanceCount = 4
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0.0, 0.0)
        
        // サークルのスケールアニメーション
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.8
        scaleAnimation.duration = 0.5
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.add(scaleAnimation, forKey: "scaleAnimation")
        
        // replicatorLayerの回転アニメーション
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = -2.0*M_PI
        rotationAnimation.duration = 6.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        replicatorLayer.add(rotationAnimation, forKey: "rotationAnimation")
        
        replicatorLayer.instanceCount = 6
        replicatorLayer.instanceDelay = 0.1
        let angle = (2.0*M_PI)/Double(replicatorLayer.instanceCount);
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0);
    }
    
    @IBAction func speakButton(_ sender: Any) {
        let image1 = UIImage(named: "fukidasi3")
        imageView2.image = image1
        
        
        let now = NSDate() // 時間取得
        let formatter = DateFormatter()
        formatter.dateFormat = "HH" // 時間のみもってくる
        let hour = Int(formatter.string(from: now as Date))
        if 5 < hour! && hour! <= 10 {
            speakLabel.text = "おはよう"
        } else if 10 < hour! && hour! <= 16{
            speakLabel.text = "こんにちは"
        } else if 16 < hour! && hour! <= 22{
            speakLabel.text = "こんばんは"
        } else {
            speakLabel.text = "おやすみ"
        }
    }
    
    @IBAction func tapButton(_ sender: Any) {
        
        let r = Int(arc4random()) % Int(ViewController.sweets.count)
        myLabel.text = ViewController.sweets[r]
        
        // ラベルの内容を保存。今はボタンが押された時だけ
        let d = UserDefaults.standard
        d.set(ViewController.sweets[r], forKey: "SWEETS")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //初回起動判定
        let ud = UserDefaults.standard
        if ud.bool(forKey: "firstLaunch") {
            
            // 初回起動時の処理
            myLabel.text = "Do you like sweets?"
            ViewController.test = 0;
            ViewController.usa = "うさしろ"
            
            let d = UserDefaults.standard
            d.set("Do you like sweets?", forKey: "SWEETS")
            // ラベルの内容を読み込む
            let l = d.object(forKey: "SWEETS") as! String!
            myLabel.text = l
            
            
            let df = UserDefaults.standard
            df.set(ViewController.test, forKey: "TEST")
            //変数testの中身を読み込んで表示
            let lf = df.object(forKey: "TEST") as! Int!
            ViewController.test = lf!
            testLabel.text = String(ViewController.test)
            
            let dd = UserDefaults.standard
            dd.set(ViewController.usa, forKey: "USA")
            let image = UIImage(named: ViewController.usa + ".PNG")
            imageView.image = image
            
            // 2回目以降の起動では「firstLaunch」のkeyをfalseに
            ud.set(false, forKey: "firstLaunch")
            
            //2回目以降の起動時の動作
        } else {
            
            // ラベルの内容を読み込む
            let d = UserDefaults.standard
            let l = d.object(forKey: "SWEETS") as! String!
            myLabel.text = l
            
            //変数testの中身を読み込んで表示
            let df = UserDefaults.standard
            let lf = df.object(forKey: "TEST") as! Int!
            ViewController.test = lf!
            testLabel.text = String(ViewController.test)
            
            //うさぎの状態をロードする
            let dd = UserDefaults.standard
            let ll = dd.object(forKey: "USA") as! String!
            if ll == "" {
                let image = UIImage(named: "うさしろ.PNG")
                imageView.image = image
            } else {
                let image = UIImage(named: ll! + ".PNG")
                imageView.image = image
            }
        }
        
        //プレゼントのアニメーション
        super.viewDidAppear(animated)
        
        //オレンジの丸が回るアニメーションを作っておく
        circle()
        //最初は消しておく
        replicatorLayer.isHidden = true;
        
        let imageLayer = CALayer()
        
        //画像をCGImageに変換する
        imageLayer.contents = UIImage(named: "present_l.png")!.cgImage
        
        imageLayer.frame = CGRect(x: -100.0, y:0.0, width:100.0, height:100.0)
        
        view.layer.insertSublayer(imageLayer,above: view.layer)
        
        //アニメーションの作成
        let characterAnimation = CAKeyframeAnimation(keyPath:"position")
        characterAnimation.duration = 8.0
        characterAnimation.repeatCount = MAXFLOAT;
        characterAnimation.values = [CGPoint(x: -100, y:0),
                                     CGPoint(x: view.frame.width+100.0, y:140.0),
                                     CGPoint(x: -100.0, y:view.frame.size.height)]
            .map{NSValue(cgPoint: $0)}
        characterAnimation.keyTimes = [0.0,0.5,1.0]
        
        imageLayer.add(characterAnimation, forKey: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ラベルの内容の初期設定
        //myLabel.text = "Do you like sweets?"
        nowAlbum.text = "Album           : Empty"
        nowPlaying.text = "Now Playing : Empty"
        nowArtist.text = "Artist             : Empty"
        
        
        player = MPMusicPlayerController.applicationMusicPlayer()
        
        //再生中のItemが変わった時に通知を受け取る
        let n = NotificationCenter.default
        n.addObserver(self, selector: #selector(ViewController.nowPlayingItemChanged(n:)), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nowPlayingItemChanged(n: NSNotification) {
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
    }

    func updateSongInformationUI(mediaItem: MPMediaItem) {
        nowAlbum.text = "Album           : " + mediaItem.albumTitle!
        nowPlaying.text = "Now Playing : " + mediaItem.title!
        nowArtist.text = "Artist             : " + mediaItem.artist!
        
        //比翼の羽根というタイトルの曲が選択されたら、変数testに10増やす
        if mediaItem.title == "比翼の羽根" {
            ViewController.test += 10
            testLabel.text = String(ViewController.test)
            
            let d = UserDefaults.standard
            d.set(ViewController.test, forKey: "TEST")
            
            //比翼の羽根以外の曲が選択されたら、変数testを5減らす
        } else {
            ViewController.test -= 5
            testLabel.text = String(ViewController.test)
            
            let d = UserDefaults.standard
            d.set(ViewController.test, forKey: "TEST")
        }
        
        //変数testの値によって、うさぎの色を変える
        if ViewController.test >= 50 {
            ViewController.usa = "うさみずいろ"
            
            let d = UserDefaults.standard
            d.set(ViewController.usa, forKey: "USA")
            
            let image = UIImage(named: ViewController.usa + ".PNG")
            imageView.image = image
        } else {
            ViewController.usa = "うさしろ"
            
            let d = UserDefaults.standard
            d.set(ViewController.usa, forKey: "USA")
            
            let image = UIImage(named: ViewController.usa + ".PNG")
            imageView.image = image
        }
    }
    
    //選択がキャンセルされた際に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        //ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pick(_ sender: Any) {
        // MPMediaPikerComtrollerのインスタンスを作成
        let picker = MPMediaPickerController()
        
        //ピッカーのデリゲートを設定
        picker.delegate = self
        
        // 複数選択不可にする（trueにすると、複数選択できるようになる）
        picker.allowsPickingMultipleItems = false
        
        //ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        player.stop()
        replicatorLayer.isHidden = true;
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをPlayerにセット
        player.setQueue(with: mediaItemCollection)
        
        if let mediaItem = mediaItemCollection.items.first {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        
        //ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func pushPlay(_ sender: Any) {
        player.play()
        replicatorLayer.isHidden = false;
    }
    
    @IBAction func pushPause(_ sender: Any) {
        player.pause()
        replicatorLayer.isHidden = true;
    }

    @IBAction func pushStop(_ sender: Any) {
        player.stop()
        replicatorLayer.isHidden = true;
    }
    
}

