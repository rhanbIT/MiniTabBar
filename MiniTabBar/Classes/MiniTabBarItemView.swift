//
//  MiniTabBarItemView.swift
//  Pods
//
//  Created by Dylan Marriott on 12/01/17.
//
//

import Foundation
import UIKit

class MiniTabBarItemView: UIView {
    let item: MiniTabBarItem
    let titleLabel = UILabel()
    let iconView = UIImageView()
    let badgeLabel = UILabel()
    
    private var selected = false
    
    override var tintColor: UIColor! {
        didSet {
            if self.selected {
                self.iconView.tintColor = self.tintColor
            }
            self.titleLabel.textColor = self.tintColor
        }
    }
    private let defaultFont = UIFont.systemFont(ofSize: 12)
    var font: UIFont? {
        didSet {
            self.titleLabel.font = self.font ?? defaultFont
        }
    }
    
    init(_ item: MiniTabBarItem) {
        self.item = item
        super.init(frame: CGRect.zero)
        
        if let customView = self.item.customView {
            assert(self.item.title == nil && self.item.icon == nil, "Don't set title / icon when using a custom view")
            if (customView.frame.width <= 0 || customView.frame.height <= 0) {
                customView.frame.size = CGSize(width: 50, height: 50)
            }
            self.addSubview(customView)
        } else {
            assert(self.item.title != nil && self.item.icon != nil, "Title / Icon not set")
            if let title = self.item.title {
                titleLabel.text = title
                titleLabel.font = self.defaultFont
                titleLabel.textColor = self.tintColor
                titleLabel.textAlignment = .center
                self.addSubview(titleLabel)
            }
            
            if let icon = self.item.icon {
                iconView.image = icon.withRenderingMode(.alwaysTemplate)
                self.addSubview(iconView)
            }

            if let badge = self.item.badge {
                badgeLabel.text = badge.value
                badgeLabel.font = self.defaultFont
                badgeLabel.textColor = badge.textColor
                badgeLabel.backgroundColor = badge.backgroundColor
                badgeLabel.textAlignment = .center
                badgeLabel.layer.cornerRadius = 6
                badgeLabel.clipsToBounds = true
                self.addSubview(badgeLabel)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customView = self.item.customView {
            customView.center = CGPoint(x: self.frame.width / 2 + self.item.offset.horizontal,
                                        y: self.frame.height / 2 + self.item.offset.vertical)
        } else {
            titleLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 14)
            iconView.frame = CGRect(x: self.frame.width / 2 - 13, y: 12, width: 25, height: 25)
            badgeLabel.frame = CGRect(x: self.frame.width / 2 + 6, y: 6, width: 12, height: 12)
        }
    }
    
    func setBadge(badgeValue: String) {
        if (badgeValue != "") {
             UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.fadeScaleOut()
            }, completion: { finished in 
                self.badgeLabel.text = badgeValue
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.fadeScaleIn();
                })
            })
        } else {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.fadeScaleOut()
            }, completion: { finished in
                self.badgeLabel.text = badgeValue
            })
        }
    }

    func fadeScaleOut() {
        self.badgeLabel.alpha = 0.0
        self.badgeLabel.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
    }
    func fadeScaleIn() {
        self.badgeLabel.alpha = 1.0
        self.badgeLabel.transform = CGAffineTransform.identity
    }


    func setSelected(_ selected: Bool, animated: Bool = true) {
        self.selected = selected
        self.iconView.tintColor = selected ? self.tintColor : UIColor(white: 0.6, alpha: 1.0)
        
        if (animated && selected) {
            /*
             ICON
             */
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.iconView.frame.origin.y = 5
            }, completion: { finished in
                UIView.animate(withDuration: 0.4, delay: 0.5, options: UIViewAnimationOptions(), animations: {
                    self.iconView.frame.origin.y = 12
                })
            })

            /*
            BADGE
            */
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.badgeLabel.frame.origin.y = 2.5
            }, completion: { finished in
                UIView.animate(withDuration: 0.4, delay: 0.5, options: UIViewAnimationOptions(), animations: {
                    self.badgeLabel.frame.origin.y = 6
                })
            })
            
            
            /*
             TEXT
             */
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.titleLabel.frame.origin.y = 28
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, delay: 0.5, options: UIViewAnimationOptions(), animations: {
                    self.titleLabel.frame.origin.y = self.frame.size.height
                })
            })
        }
    }
}
