//
//  ViewController.swift
//  debottle
//
//  Created by Richie Shilton on 21/2/19.
//

import UIKit
//MARK: 1
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    
    private var interval: Double = 2.0
    
    @IBOutlet weak var debounceButton: UIButton!
    @IBOutlet weak var throttleButton: UIButton!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    private var bag = DisposeBag()

    private var debouncer: Observable<Void>?
    private var throttler: Observable<Void>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViews()
    }
    
    @IBOutlet weak var intervalslider: UISlider!
    @IBAction func slider(_ sender: Any) {
        if let slider = sender as? UISlider {
            let newInterval = floor(slider.value)
            
            interval = Double(newInterval)
            intervalLabel.text = "\(newInterval) s"
            
            bag = DisposeBag()
            bindViews()
        }
    }
    
    private func bindViews() {
        
        debounceButton.rx.tap.asObservable()
        .debounce(interval, scheduler: MainScheduler.instance)
            .do(onNext: { (_) in
                print("debounceButton tapped")
                self.debounceTapped()
            })
            .subscribe()
            .disposed(by: bag)
        
        throttleButton.rx.tap.asObservable()
            .throttle(interval, latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { (_) in
                print("throttleButton tapped")
                self.throttleTapped()
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    private func debounceTapped() {
        start()
        label.text = "DEBOUNCED!"
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.end()
                self.view.backgroundColor = .white
            }
        }
    }
    
    private func throttleTapped() {
        start()
        label.text = "THROTTLED!"
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.end()
                self.view.backgroundColor = .white
            }
        }
    }
    
    private func start() {
        debounceButton.isHidden = true
        throttleButton.isHidden = true
        intervalslider.isHidden = true
    }
    
    private func end() {
        debounceButton.isHidden = false
        throttleButton.isHidden = false
        intervalslider.isHidden = false
    }
}

