//
//  CommentCell.swift
//  Instagram
//
//  Created by Fahad Almehawas on 6/3/17.
//  Copyright © 2017 Fahad Almehawas. All rights reserved.
//
//
protocol CommentCellDelegate {
    func didLikeComment(cell: CommentCell, comment: Comment)
    func didTapAvatar(user: Users)
}
import UIKit
class CommentCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupviews()
    }
    
    var delegate: CommentCellDelegate?
    var comment: Comment? {
        didSet {
            guard let urlString = comment?.user.userProfileImageUrl else {return}
            userprofileImageView.loadImage(urlString: urlString)
            setupAttributedCaption()
            let timeAgoDisplay = comment?.creationDate.timeAgoDisplay()

            timeLabel.text = timeAgoDisplay
        }
    }
    
    fileprivate func setupAttributedCaption() {
        guard let comment = self.comment else { return }
        
        let attributedText = NSMutableAttributedString(string: comment.user.userName, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)])
        
        guard let caption = comment.captionText else {return}
        attributedText.append(NSAttributedString(string: " \(caption)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]))
        
        userFullname.attributedText = attributedText
        userFullname.numberOfLines = 0
    }

    
    
    
     @objc func handleNavigateToProfile() {
        print("TAP TAP TAP")
        guard let user = comment?.user else {return}
        delegate?.didTapAvatar(user: user)
    }
    
    lazy var userprofileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .red
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToProfile))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    
    lazy var userFullname: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = "Fahad Mussa"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNavigateToProfile))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var commentText: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = "Yea I'm the Mussa"
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "favorite-heart-button").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let replyButton: UILabel = {
        let label = UILabel()
        label.text = "Reply"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    
    @objc func handleLike() {
        guard let comment = comment else {return}
        delegate?.didLikeComment(cell: self, comment: comment)
        
    }

    let commentLikeCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    
    func setupviews() {
        addSubview(userprofileImageView)
        addSubview(userFullname)
        addSubview(timeLabel)
        addSubview(replyButton)
        addSubview(likeButton)
        addSubview(commentLikeCount)
        userprofileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        userprofileImageView.layer.cornerRadius = 60 / 2
        
        userFullname.anchor(top: userprofileImageView.topAnchor, left: userprofileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
      
        setupStackviews()
    }
    
    func setupStackviews() {
        let stackview = UIStackView(arrangedSubviews: [timeLabel, commentLikeCount, replyButton])
        
        addSubview(stackview)
        addSubview(likeButton)
        addSubview(lineView)

        stackview.axis = .horizontal
        stackview.spacing = 10
        stackview.anchor(top: userFullname.bottomAnchor, left: userFullname.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 13)
        
        likeButton.anchor(top: userFullname.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
          lineView.anchor(top: userprofileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
