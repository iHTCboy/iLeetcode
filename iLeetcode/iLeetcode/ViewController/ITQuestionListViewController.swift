//
//  ITQuestionListViewController.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit

class ITQuestionListViewController: UIViewController {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // language
        switch IHTCUserDefaults.shared.getUDLanguage() {
            case "zh_CN":
                isShowZH = true
                break
            case "en_US":
                isShowZH = false
                break
            default: break
        }
        
        tableView.reloadData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let refreshControl = UIRefreshControl.init()
    var selectedCell: ITQuestionListViewCell!
    var isShowZH : Bool = false
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        #if targetEnvironment(macCatalyst)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 1024, right: 0)
        #endif
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 80
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib.init(nibName: "ITQuestionListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ITQuestionListViewCell")
        self.refreshControl.addTarget(self, action: #selector(randomRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl)
        return tableView
    }()
    
    lazy var listModel: ITModel = {
        if ILeetCoderModel.shared.defaultArray.contains(self.title!) {
            return ILeetCoderModel.shared.defaultData()[self.title!]!
            
        } else if ILeetCoderModel.shared.tagsArray.contains(self.title!) {
            return ILeetCoderModel.shared.tagsData()[self.title!]!
            
        } else if ILeetCoderModel.shared.enterpriseArray.contains(self.title!) {
            return ILeetCoderModel.shared.enterpriseData()[self.title!]!
            
        } else {
            print("no featch title")
            return ITModel()
        }
    }()
}


// MARK:- Prive mothod
extension ITQuestionListViewController {
    fileprivate func setUpUI() {
        // backgroundColor
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemGroupedBackground
        }
        
        // tableview
        view.addSubview(tableView)
        let constraintViews = [
            "tableView": tableView
        ]
        let tabBarHeight = 58
        let vFormat = "V:|-0-[tableView]-\(tabBarHeight)-|"
        let hFormat = "H:|-0-[tableView]-0-|"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vFormat, options: [], metrics: [:], views: constraintViews)
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hFormat, options: [], metrics: [:], views: constraintViews)
        view.addConstraints(vConstraints)
        view.addConstraints(hConstraints)
        view.layoutIfNeeded()

        #if !targetEnvironment(macCatalyst)
        // 判断系统版本，必须iOS 9及以上，同时检测是否支持触摸力度识别
        if #available(iOS 9.0, *), traitCollection.forceTouchCapability == .available {
            // 注册预览代理，self监听，tableview执行Peek
            registerForPreviewing(with: self, sourceView: tableView)
        }
        #endif
    }
    
    @objc public func randomRefresh(sender: AnyObject) {
        self.listModel.result.shuffle()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: Tableview Delegate
extension ITQuestionListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITQuestionListViewCell = tableView.dequeueReusableCell(withIdentifier: "ITQuestionListViewCell") as! ITQuestionListViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.numLbl.layer.cornerRadius = 3
        cell.numLbl.layer.masksToBounds = true
        cell.numLbl.adjustsFontSizeToFitWidth = true
        cell.numLbl.baselineAdjustment = .alignCenters
        cell.tagLbl.layer.cornerRadius = 3
        cell.tagLbl.layer.masksToBounds = true
        cell.tagLbl.adjustsFontSizeToFitWidth = true
        cell.tagLbl.baselineAdjustment = .alignCenters
        cell.langugeLbl.layer.cornerRadius = 3
        cell.langugeLbl.layer.masksToBounds = true
        cell.langugeLbl.adjustsFontSizeToFitWidth = true
        cell.langugeLbl.baselineAdjustment = .alignCenters
        cell.frequencyLbl.layer.cornerRadius = 3
        cell.frequencyLbl.layer.masksToBounds = true
        cell.frequencyLbl.adjustsFontSizeToFitWidth = true
        cell.frequencyLbl.baselineAdjustment = .alignCenters
        
        #if targetEnvironment(macCatalyst)
        cell.questionLbl.font = UIFont.systemFont(ofSize: 20)
        #endif
        
        let question = self.listModel.result[indexPath.row]
        cell.numLbl.text =  " #" + question.leetId + " "
        let difZh = (question.difficulty == "Easy" ? "容易" : (question.difficulty == "Medium" ? "中等" : "困难" ))
        cell.tagLbl.text =  " " + (isShowZH ? difZh : question.difficulty) + " "
        cell.tagLbl.backgroundColor = ILeetCoderModel.shared.colorForKey(level: question.difficulty)
        cell.frequencyLbl.text = " " + (question.frequency.count < 3 ? (question.frequency + ".0%") : question.frequency) + " "
        
        if ILeetCoderModel.shared.defaultArray.contains(self.title!) {
            if question.tagString.count > 0 {
                cell.langugeLbl.text =  " " + (isShowZH ? question.tagStringZh : question.tagString).componentsJoined(by: " · ") + " "
                cell.langugeLbl.backgroundColor = kColorAppGray
                cell.langugeLbl.isHidden = false
            }
            else {
                cell.langugeLbl.text = ""
                cell.langugeLbl.isHidden = true
            }
        }
        
        if ILeetCoderModel.shared.tagsArray.contains(self.title!) {
            cell.langugeLbl.text =  " " + self.title! + "   "
            cell.langugeLbl.backgroundColor = kColorAppGray
            cell.langugeLbl.isHidden = false
            
            if let tags = question.tags as? [Dictionary<String, String>] {
                for tag in tags {
                    let tagEn = tag["tag"]
                    let tagZh = tag["tagZh"]
                    if self.title! == tagEn || self.title! == tagZh {
                        cell.langugeLbl.text = " " + ((isShowZH ? tagZh : tagEn)!) + "   "
                        break
                    }
                }
            }
        }
        
        if ILeetCoderModel.shared.enterpriseArray.contains(self.title!) {
            cell.langugeLbl.text =  " " + self.title! + "   "
            cell.langugeLbl.backgroundColor = kColorAppGray
            cell.langugeLbl.isHidden = false
        }
        
        switch IHTCUserDefaults.shared.getUDLanguage() {
            case "zh_CN":
                cell.questionLbl.text = question.titleZh.count > 0 ? question.titleZh : question.title
                break
            case "en_US":
                cell.questionLbl.text = question.title
                break
            default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! ITQuestionListViewCell)
    
        let question = self.listModel.result[indexPath.row]
        let questionVC = ITQuestionDetailViewController()
        questionVC.title = self.title
        questionVC.currentIndex = indexPath.row
        questionVC.questionsArray = self.listModel.result
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}


// MARK: 随机数
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


#if !targetEnvironment(macCatalyst)
// MARK: - UIViewControllerPreviewingDelegate
@available(iOS 9.0, *)
extension ITQuestionListViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        // 模态弹出需要展现的控制器
        //        showDetailViewController(viewControllerToCommit, sender: nil)
        // 通过导航栏push需要展现的控制器
        show(viewControllerToCommit, sender: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // 获取indexPath和cell
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else { return nil }
        // 设置Peek视图突出显示的frame
        previewingContext.sourceRect = cell.frame
        
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! ITQuestionListViewCell)
        
        let question = self.listModel.result[indexPath.row]
        let questionVC = ITQuestionDetailViewController()
        questionVC.title = self.title
        questionVC.currentIndex = indexPath.row
        questionVC.questionsArray = self.listModel.result
        questionVC.questionModle = question
        questionVC.hidesBottomBarWhenPushed = true
        
        // 返回需要弹出的控制权
        return questionVC
    }
}
#endif
