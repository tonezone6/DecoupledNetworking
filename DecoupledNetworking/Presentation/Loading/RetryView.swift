//
//  HeadsupView.swift
//  DecoupledNetworking
//
//  Created by Alex on 18/01/2020.
//  Copyright © 2020 tonezone6. All rights reserved.
//

import UIKit

protocol RetryViewDelegate: class {
    func headsupViewDidTapRetry(_: RetryView)
}

final class RetryView: UIView {
    weak var delegate: RetryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init()
        setup(with: message)
    }
    
    @objc private func retryTapped(sender: UIButton) {
        delegate?.headsupViewDidTapRetry(self)
    }
    
    private func setup(with message: String) {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "exclamationmark.bubble.fill")
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16) //, weight: .medium)
        button.setTitle("Retry", for: .normal)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(retryTapped(sender:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.constrainEdges(to: self)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
    }
}