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
        view.lineColor = UIColor.black.cgColor
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
    
    fileprivate let lineWidthSlider: UISlider = {
        let slider = UISlider()
        slider.sizeToFit()
        slider.maximumValue = 30
        slider.minimumValue = 1
        slider.tintColor = .black
        return slider
    }()
    
    
    // MARK - Properties -
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: ViewModel
    
    
    // MARK - Initilaizer
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK - Life Cycle Events

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confugure()
        setViews()
        setConstraints()
        subscribeView()
        subscribeViewModel()
    }
    
    fileprivate func confugure() {
        self.view.backgroundColor = .white
    }
    
    fileprivate func setViews() {
        self.view.addSubview(drawView)
        self.view.addSubview(imageView)
        self.view.addSubview(undoButton)
        self.view.addSubview(redoButton)
        self.view.addSubview(lineWidthSlider)
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
        
         lineWidthSlider.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(64)
            make.bottom.equalTo(view.snp.bottom).inset(64)
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
        
        lineWidthSlider.rx.value.subscribe(onNext: {[weak self] value in
            self?.viewModel.sliderValue.value = Float(value)
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func subscribeViewModel() {
        lineWidthSlider.rx.value.subscribe(onNext: {[weak self] (value) in
            self?.drawView.lineWidth = CGFloat((self?.viewModel.sliderValue.value)!)
        })
            .addDisposableTo(disposeBag)
    }
}
