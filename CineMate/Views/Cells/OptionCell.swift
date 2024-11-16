//
//  OptionCell.swift
//  CineMate
//
//  Created by Ritika Gupta on 01/11/24.
//

import UIKit

class OptionCell: UITableViewCell {
    static let identifier = "OptionCell"
    var titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Constants.Fonts.gothicRegular, size: 18)
        
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setup(viewModel: OptionCellModel) {
        self.titleLabel.text = viewModel.title
        self.indentationLevel = viewModel.indentationLevel
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        imageView.image = viewModel.isExpanded ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        self.accessoryView = imageView
    }
}
