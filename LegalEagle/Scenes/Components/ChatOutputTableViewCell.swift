//
//  ChatOutputTableViewCell.swift
//  LegalEagle
//
//  Created by BoMin Lee on 12/3/23.
//

import UIKit

class ChatOutputTableViewCell: UITableViewCell {
    static let identifier: String = String(describing: ChatOutputTableViewCell.self)
    var chatInputText: String? = nil
    
    private var mainContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .legalBlue
        view.layer.masksToBounds = true
        view.roundCorners(cornerRadius: 15, maskedCorners: [ .layerMinXMinYCorner,
                                                             .layerMaxXMaxYCorner,
                                                             .layerMaxXMinYCorner])
        
        return view
    }()
    
    private var contextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(size: 16)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .natural
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    func addSubviews() {
        self.contentView.addSubviews(mainContainerView)
        
        mainContainerView.addSubviews(chatContainerView)
        chatContainerView.addSubviews(contextLabel)
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(mainContainerView)
            make.leading.trailing.equalToSuperview()
        }
        
        mainContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(260)
            make.bottom.equalTo(contextLabel).offset(16)
        }
        
        chatContainerView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        
        contextLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func updateChatOutput(_ chatInputText: String) {
        self.chatInputText = chatInputText
        contextLabel.text = chatInputText
        
        layoutIfNeeded()
    }
}
