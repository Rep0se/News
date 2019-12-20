//
//  HeadlineTableViewCell.swift
//  News
//
//  Created by Alexander Sundiev on 2019-12-19.
//  Copyright © 2019 Alexander Sundiev. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    var cell: Article? {
        didSet{
            guard let unwrappedCell = cell else { return }
            titleLabel.text = unwrappedCell.title
            authorLabel.text = unwrappedCell.author
            
            let dateTime = unwrappedCell.publishedAt
            if let index = dateTime.range(of: "T")?.lowerBound {
                let substring = dateTime[..<index]
                let string = String(substring)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: string) {
                    dateFormatter.dateStyle = .medium
                    dateLabel.text = dateFormatter.string(from: date).uppercased()
                }
            }
            
            if let urlString = unwrappedCell.urlToImage {
                thumbnailImageView.loadImageUsingUrlString(urlString: urlString)
            }
            if let content = unwrappedCell.content {
                if let index = content.range(of: "[")?.lowerBound{
                    let substring = content[..<index]
                    let string = String(substring)
                    contentLabel.text = string
                }
            }
            
            sourceLabel.text = unwrappedCell.source.name
        }
    }
    
    // MARK: - UI Objects
    private let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Article Title"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author Label"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.tintColor = .lightGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DEC 12, 2019"
        label.font = .preferredFont(forTextStyle: .caption2)
        label.tintColor = .lightGray
        return label
    }()
    
    private let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let bodyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Content"
        label.font = .systemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Source Label"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.tintColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Layout
    private func setupLayout(){
        contentView.addSubview(headerContainerView)
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(authorLabel)
        headerContainerView.addSubview(dateLabel)
        headerContainerView.addSubview(thumbnailImageView)
        
        contentView.addSubview(bodyContainerView)
        bodyContainerView.addSubview(contentLabel)
        bodyContainerView.addSubview(sourceLabel)
        
        headerContainerView.anchorWithConstantsTo(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0)
        titleLabel.anchorWithConstantsTo(top: headerContainerView.topAnchor, left: headerContainerView.leftAnchor, bottom: nil, right: thumbnailImageView.leftAnchor, topPadding: 8, leftPadding: 16, bottomPadding: 0, rightPadding: 8)
        authorLabel.anchorWithConstantsTo(top: titleLabel.bottomAnchor, left: headerContainerView.leftAnchor, bottom: nil, right: thumbnailImageView.leftAnchor, topPadding: 8, leftPadding: 16, bottomPadding: 0, rightPadding: 8)
        dateLabel.anchorWithConstantsTo(top: authorLabel.bottomAnchor, left: headerContainerView.leftAnchor, bottom: nil, right: thumbnailImageView.leftAnchor, topPadding: 0, leftPadding: 16, bottomPadding: 0, rightPadding: 8)
        thumbnailImageView.anchorWithConstantsTo(top: headerContainerView.topAnchor, left: nil, bottom: headerContainerView.bottomAnchor, right: headerContainerView.rightAnchor, topPadding: 24, leftPadding: 0, bottomPadding: 24, rightPadding: 16)
        
        bodyContainerView.anchorWithConstantsTo(top: headerContainerView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 4, rightPadding: 0)
        contentLabel.anchorWithConstantsTo(top: bodyContainerView.topAnchor, left: bodyContainerView.leftAnchor, bottom: nil, right: bodyContainerView.rightAnchor, topPadding: 0, leftPadding: 16, bottomPadding: 0, rightPadding: 16)
        sourceLabel.anchorWithConstantsTo(top: contentLabel.bottomAnchor, left: bodyContainerView.leftAnchor, bottom: bodyContainerView.bottomAnchor, right: bodyContainerView.rightAnchor, topPadding: 0, leftPadding: 16, bottomPadding: 8, rightPadding: 16)
        
        NSLayoutConstraint.activate([
//            headerContainerView.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, constant: 16),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 64),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
        
    }

    // MARK: - Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
