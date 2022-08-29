//
//  ViewController.swift
//  pomodoro
//
//  Created by Nortiz M1 on 2022/08/27.
//

import UIKit

enum TimerStatus {
	case start
	case pause
	case end
}

class ViewController: UIViewController {

	@IBOutlet weak var toggleButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var timeLabel: UILabel!
	
	// 타이머에 저장된 시간을 '초'로 저장하는 프로퍼티
	// 타이머의 초기 설정 값으로 초기화
	var duration = 60
	
	// 타이머의 상태값을 저장하는 프로퍼티
	var timerStatus: TimerStatus = .end
	
	var timer: DispatchSourceTimer?
	var currentSeconds = 0
	
	// MARK: - 뷰
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureToggleButton()
	}

	func setTimerInfoViewVisible(isHidden: Bool) {
		self.timeLabel.isHidden = isHidden
		self.progressView.isHidden = isHidden
	}
	
	func configureToggleButton() {
		// 버튼의 상태에 따라 타이틀을 변경한다.
		self.toggleButton.setTitle("START", for: .normal)
		self.toggleButton.setTitle("PAUSE", for: .selected)
	}
	
	// MARK: - 타이머 시작&종료
	func startTimer() {
		if self.timer == nil {
			self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
			self.timer?.schedule(deadline: .now(), repeating: 1)
			self.timer?.setEventHandler(handler: { [weak self] in
				self?.currentSeconds -= 1
				
				if self?.currentSeconds ?? 0 <= 0 {
					self?.stopTimer()
				}
			})
			self.timer?.resume()
		}
	}
	
	func stopTimer() {
		if self.timerStatus == .pause {
			self.timer?.resume()
		}
		self.timerStatus = .end
		self.setTimerInfoViewVisible(isHidden: true)
		self.datePicker.isHidden = false
		self.cancelButton.isEnabled = false
		self.toggleButton.isSelected = false
		self.timer?.cancel()
		self.timer = nil
	}
	
	// MARK: - 액션버튼 메서드
	@IBAction func tabToggleButton(_ sender: UIButton) {
		self.duration = Int(self.datePicker.countDownDuration)
		switch self.timerStatus {
		case .end:
			self.currentSeconds = self.duration
			self.timerStatus = .start
			self.setTimerInfoViewVisible(isHidden: false)
			self.datePicker.isHidden = true
			self.toggleButton.isSelected = true
			self.cancelButton.isEnabled = true
			self.startTimer()
			
		case .start:
			self.timerStatus = .pause
			self.toggleButton.isSelected = false
			self.timer?.suspend()
			
		case .pause:
			self.timerStatus = .start
			self.toggleButton.isSelected = true
			self.timer?.resume()
		}
	}
	
	@IBAction func tapCancelButton(_ sender: UIButton) {
		switch timerStatus {
		case .start, .pause:
			self.stopTimer()
			
		case .end:
			break
		}
	}
}

