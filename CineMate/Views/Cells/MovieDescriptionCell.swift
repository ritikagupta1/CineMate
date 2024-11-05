//
//  MovieDescriptionCell.swift
//  CineMate
//
//  Created by Ritika Gupta on 01/11/24.
//

import UIKit

class MovieDescriptionCell: UITableViewCell {
    static let identifier = "MovieDescriptionCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.gothicBold, size: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.gothicRegular, size: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.Fonts.gothicRegular, size: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, yearLabel, languageLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(detailsStack)
        
        NSLayoutConstraint.activate([
            // Poster image constraints
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
               posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
               posterImageView.heightAnchor.constraint(equalToConstant: 240),
               posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            detailsStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
                detailsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                detailsStack.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            detailsStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with movie: Movie) {
        self.indentationLevel = 2
        self.backgroundColor = .clear
        self.accessoryView = nil
        titleLabel.text = movie.title
        yearLabel.text = "Year: \(movie.year)"
        let languages = movie.language
        languageLabel.text = "Language: \(languages)"
        
        NetworkManager.shared.downloadImage(from: movie.poster) { [weak self] image in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.posterImageView.image = image ?? .placeholder
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
        languageLabel.text = nil
    }
}
