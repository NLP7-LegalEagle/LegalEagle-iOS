//
//  HomeViewController.swift
//  LegalEagle
//
//  Created by BoMin Lee on 11/20/23.
//

import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    private var inputText = [""]
    private var outputText = [""]
    
    var activityIndicator: UIActivityIndicatorView?
    var isLoadingData = false
    
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
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        let configuraiton = UIImage.SymbolConfiguration(font: .pretendard(size: 20))
        var image = LegalEagleImageCollection.questionIconImage
        image = image.withConfiguration(configuraiton)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(othersButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(othersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.isHidden = true
        
        return view
    }()
    
    private lazy var warningView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.isHidden = true
        
        return view
    }()
    
    private lazy var warningTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "WARNING"
        label.textColor = .legalBlue
        label.font = .pretendard(size: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "This AI-generated content should not be considered legal advice. Always consult a qualified legal professional for important legal matters."
        label.textColor = .black
        label.font = .pretendard(size: 15, weight: .semiBold)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var textInputContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.legalGray.cgColor
        
        return view
    }()
    
    private var inputTextField: UITextField = {
        let field = UITextField()
        
        let placeholderText = "Write your case here."
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.legalGray]
        field.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        field.autocorrectionType = .no
        
        field.font = .pretendard(size: 15)
        field.textColor = .black
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        field.leftViewMode = .always
        
        return field
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 24
        button.isEnabled = false
        button.setImage(LegalEagleImageCollection.sendIconDisabledImage, for: .normal)
        return button
    }()
    
    private var chatView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
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
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(ChatInputTableViewCell.self,
                               forCellReuseIdentifier: ChatInputTableViewCell.identifier)
        chatTableView.register(ChatOutputTableViewCell.self,
                               forCellReuseIdentifier: ChatOutputTableViewCell.identifier)
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 100
        
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        let dimTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideWarningView))
        dimView.addGestureRecognizer(dimTapGesture)
    }
    
    private func addSubviews() {
        
        self.view.addSubviews(topView, bottomView, chatView, dimView, warningView)
        
        self.topView.addSubviews(titleLabel, infoButton)
        
        self.bottomView.addSubviews(textInputContainerView, sendButton)
        
        self.textInputContainerView.addSubviews(inputTextField)
        
        self.chatView.addSubviews(eagleCircleImageView, chatTableView)
        
        self.warningView.addSubviews(warningTitleLabel, warningLabel)
    }
    
    private func makeConstraint() {
        topView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        infoButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().inset(30)
            make.width.height.equalTo(33)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(infoButton)
            make.centerX.equalToSuperview()
        }
        
        dimView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        warningView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(150)
        }
        
        warningTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(warningTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        bottomView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        chatView.snp.makeConstraints{ make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(bottomView.snp.top).offset(-10)
        }
        
        chatTableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        eagleCircleImageView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.height.equalTo(50)
        }
        
        sendButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(textInputContainerView)
            make.width.equalTo(sendButton.snp.height)
        }
        
        textInputContainerView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-9)
            make.height.equalTo(48)
        }
        
        inputTextField.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc private func othersButtonTapped() {
        dimView.isHidden = false
        warningView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 1
            self.warningView.alpha = 1
        }
    }
    
    @objc private func hideWarningView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dimView.alpha = 0
            self.warningView.alpha = 0
        }) { _ in
            self.dimView.isHidden = true
            self.warningView.isHidden = true
        }
    }
    
    
    @objc private func sendButtonTapped() {
        sendInputText(inputTextField.text)
    }
    
    private func sendInputText(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            print("No text to send")
            return
        }
        
        NetworkModel.shared.sendText(text: text)
            .receive(on: DispatchQueue.main)
            .sink { error in
//                print(error)
            } receiveValue: { output in
//                self.inputTextField.text = output.output
                print(output.output)
                self.outputText.append(output.output)
                self.showCustomIndicator(for: 2) {
                    self.chatTableView.reloadData()
                }
            }
            .store(in: &cancellable)
        
        self.inputText.append(text)
        self.chatTableView.reloadData()
        
        //MARK: 텍스트 서버에 전송하는 함수 호출
        // sendInputText(text)
        
        // inputTextField 비우기
        inputTextField.text = ""
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, keyboardWillShow: true)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        adjustViewForKeyboard(notification: notification, keyboardWillShow: false)
    }
    
    private func adjustViewForKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        let animationDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        if keyboardWillShow {
            bottomView.snp.updateConstraints { make in
                make.bottom.equalTo(additionalSafeAreaInsets).offset(-keyboardHeight)
            }
        } else {
            bottomView.snp.updateConstraints { make in
                make.bottom.equalTo(additionalSafeAreaInsets).inset(15)
            }
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showCustomIndicator(for seconds: Int, completion: @escaping () -> Void) {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        isLoadingData = true

        activityIndicator = indicator // 나중에 중지 가능

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            completion()

            self.isLoadingData = false
//            self.chatTableView.reloadData()
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            self.sendButton.isEnabled = false
            self.sendButton.setImage(LegalEagleImageCollection.sendIconDisabledImage, for: .normal)
            return
        }
        
        self.sendButton.isEnabled = true
        self.sendButton.setImage(LegalEagleImageCollection.sendIconImage, for: .normal)
//        print(text)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableviewNumberOfRowsInSection = (self.inputText.count-1) + (self.outputText.count-1)
        
        return tableviewNumberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row%2 == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatOutputTableViewCell.identifier) as? ChatOutputTableViewCell else {
                return UITableViewCell()
            }
            if self.outputText.count > 1 {
                let chatOutputText = self.outputText[(indexPath.row+1)/2]
                print(chatOutputText)
                cell.updateChatOutput(chatOutputText)
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatInputTableViewCell.identifier) as? ChatInputTableViewCell else {
                return UITableViewCell()
            }
            if self.inputText.count > 1 {
                let chatInputText = self.inputText[(indexPath.row+2)/2]
                print(chatInputText)
                cell.updateChatInput(chatInputText)
            }
            
            return cell
        }
        
        
//        
//        showCustomIndicator(for: 5) {
//            print("End Indicator")
//        }
//        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

