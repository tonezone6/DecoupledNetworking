//
//  SubtitleTableViewCell.swift
//  DecoupledNetworking
//
//  Created by Alex on 17/01/2020.
//  Copyright © 2020 tonezone6. All rights reserved.
//

import UIKit

final class SubtitleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SubtitleCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with comment: Comment) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let title = formatter.string(from: NSNumber(value: comment.id))
        
        titleLabel.text = title?.capitalized
        subtitleLabel.text = comment.name
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 8.0
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        container.constrainEdges(
            to: self, insets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        )

        titleLabel.font = .systemFont(ofSize: 18, weight: .light)
        titleLabel.textColor = .black
       
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .lightGray
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        stackView.constrainEdges(
            to: container, insets: UIEdgeInsets(value: 16)
        )
    }
}

