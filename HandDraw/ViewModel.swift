//
//  ViewModel.swift
//  HandDraw
//
//  Created by Shoichi Kanzaki on 2018/02/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import RxSwift

final class ViewModel {
    private let disposeBag = DisposeBag()
    
    var sliderValue: Variable<Float>
    
    init() {
        self.sliderValue = Variable(Float(5.0))
    }
}
