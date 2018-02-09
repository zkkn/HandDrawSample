//
//  ViewController.swift
//  HandDraw
//
//  Created by Shoichi Kanzaki on 2018/02/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import SNDrawableView

class ViewController: UIViewController {

    // MARK - Views
    
    fileprivate lazy var drawView: DrawableView = {
        let view = DrawableView()
        view.lineColor = UIColor.green.cgColor
        view.lineWidth = 12.0
        return view
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate let undoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()

    fileprivate let redoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
}


// MARK - Life Cycle Events

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confugure()
        setViews()
        setConstraints()
        subscribeView()
    }
    
    fileprivate func confugure() {
        self.view.backgroundColor = .white
    }
    fileprivate func setViews() {
        self.view.addSubview(drawView)
        self.view.addSubview(imageView)
        self.view.addSubview(undoButton)
        self.view.addSubview(redoButton)
    }
    
    fileprivate func setConstraints() {
        drawView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        
        imageView.snp.makeConstraints( { make in
            make.left.equalTo(view)
            make.top.equalTo(100)
            make.width.height.equalTo(100)
        })
        
        undoButton.snp.makeConstraints { make in
            make.left.top.equalTo(view)
            make.width.height.equalTo(100)
        }
        
        redoButton.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(undoButton.snp.right).offset(100)
            make.width.height.equalTo(100)
        }
    }
    
    fileprivate func subscribeView() {
        undoButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.imageView.image = self?.drawView.getImage()
            self?.drawView.undo()
        })
        .disposed(by: disposeBag)
        
        redoButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.imageView.image = self?.drawView.getImage()
            self?.drawView.redo()
        })
        .disposed(by: disposeBag)
    }
}
