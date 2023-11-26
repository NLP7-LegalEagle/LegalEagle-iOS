//
//  HomeViewController.swift
//  LegalEagle
//
//  Created by BoMin Lee on 11/20/23.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Legal Eagle"
        label.font = .pretendard(size: 20, weight: .semiBold)
        return label
    }()
    
    private lazy var othersButton: UIButton = {
        let button = UIButton()
        button.setImage(LegalEagleImageCollection.otherIconImage, for: .normal)
        return button
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var textInputContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17.5
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.legalGray.cgColor
        
        return view
    }()
    
    private var inputTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Write your case here."
        field.textColor = .legalGray
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        field.leftViewMode = .always

        return field
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(LegalEagleImageCollection.sendIconImage, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var chatScrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()
    
    private var chatView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var eagleCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = LegalEagleImageCollection.eagleCircleIconImage
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        makeConstraint()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        
        inputTextField.delegate = self
        
        // 키보드 알림 추가
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func addSubviews() {
        self.view.addSubviews(topView, bottomView, chatScrollView)
        
        self.topView.addSubviews(titleLabel, othersButton)
        self.bottomView.addSubviews(textInputContainerView, sendButton)
        self.textInputContainerView.addSubviews(inputTextField)
        self.chatScrollView.addSubview(chatView)
        
        self.chatView.addSubviews(eagleCircleImageView)
    }
    
    private func makeConstraint() {
        topView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        othersButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(33)
            make.centerY.equalTo(titleLabel)
        }
        
        bottomView.snp.makeConstraints{ make in
            make.bottom.equalTo(additionalSafeAreaInsets).inset(15)
//            make.bottom.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        chatScrollView.snp.makeConstraints{ make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        chatView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(500)
        }
        
        eagleCircleImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.height.equalTo(50)
        }
        
        sendButton.snp.makeConstraints{ make in
//            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(13)
            make.width.height.equalTo(36)
        }
        
        textInputContainerView.snp.makeConstraints{ make in
//            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(sendButton.snp.leading).offset(-9)
            make.height.equalTo(35)
        }
        
        inputTextField.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    @objc func sendButtonTapped() {
        guard let text = inputTextField.text, !text.isEmpty else {
            print("No text to send")
            // Please Input Text 알림 띄워도 좋을 듯
            return
        }
                
        //MARK: 텍스트 서버에 전송하는 함수 호출
        // sendInputText(text)
    }
    
    private func sendInputText(_ text: String) {
        
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, keyboardWillShow: true)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, keyboardWillShow: false)
    }

    func adjustViewForKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        let animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if keyboardWillShow {
            bottomView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-keyboardHeight)
            }
        } else {
            bottomView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
