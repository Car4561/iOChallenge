//
//  UIView+Constraints.swift
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

import UIKit

public extension UIView {
    
    func pinToSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
            ]
        )
    }
    
    func pinToSafeAreaSuperview(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: insets.left),
                rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -insets.right),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
            ]
        )
    }
    
    func centerInParent() {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ]
        )
    }
    
    func centerVertically(with horizontalPadding: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: horizontalPadding),
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -horizontalPadding),
            ]
        )
    }
    
    func centerHorizontally(with vertialPadding: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                topAnchor.constraint(equalTo: superview.topAnchor, constant: vertialPadding),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -vertialPadding),
            ]
        )
    }
    
    func setSquareForm(with size: CGFloat) {
        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: size),
                heightAnchor.constraint(equalTo: widthAnchor)
            ]
        )
    }
    
    func setSize(with size: CGSize) {
        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: size.width),
                heightAnchor.constraint(equalToConstant: size.height)
            ]
        )
    }
    
    func setHorizontalEdges(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right),
            ]
        )
    }
    
    func setVerticalEdges(with insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            fatalError("No superview found")
        }
        NSLayoutConstraint.activate(
            [
                topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
            ]
        )
    }
}

public extension UIEdgeInsets {
    
    init(
        left: CGFloat = 0,
        top: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0
    ) {
        self.init(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
    
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
    
    init(constant: CGFloat) {
        self.init(
            top: constant,
            left: constant,
            bottom: constant,
            right: constant
        )
    }
    
}
