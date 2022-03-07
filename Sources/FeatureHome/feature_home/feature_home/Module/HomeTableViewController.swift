//
//  HomeTableViewController.swift
//  Home
//
//  Created by Johan Torell on 2021-02-25.
//

import enum FolksamCommon.FolksamColor
import Foundation
import FolksamCommon
import UIKit

private enum Sections {
    case user
    case policies
}

protocol HomeTableDelegate: UIViewController {}

class HomeTableViewController: UITableViewController {
    private let sections: [Sections] = [.user, .policies]
    private var policies: [Policy] = []
    private var user: ParentUser?
    weak var delegate: HomeTableDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserCell", bundle: Bundle(for: Self.self)), forCellReuseIdentifier: "UserCell")
        tableView.register(UINib(nibName: "PolicyCell", bundle: Bundle(for: Self.self)), forCellReuseIdentifier: "PolicyCell")
    }

    func setData(user: ParentUser, policies: [Policy]) {
        self.user = user
        self.policies = policies
        tableView.reloadData()
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
//        let sectionLabel = PaddingLabel(frame: CGRect(x: 8, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let sectionLabel = SectionHeaderView()

//        sectionLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
//        sectionLabel.textColor = UIColor.black
//        sectionLabel.sizeToFit()

        switch section {
        case .user:
            let text = user != nil ? "Hej \(user?.firstname?.capitalizingFirstLetter() ?? "")!" : ""
            sectionLabel.set(title: text)
        case .policies:
            sectionLabel.set(title: "Försäkringar")
        }
//
        return sectionLabel
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .user:
            return 1
        case .policies:
            return policies.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .user:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell, let user = self.user else { return UITableViewCell() }
            cell.configure(user: user)
            return cell

        case .policies:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyCell") as? PolicyCell else { return UITableViewCell() }
            cell.configure(policy: self.policies[indexPath.row])
            return cell
        }
    }

    override func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return SectionHeaderView.height
    }
}

class SectionHeaderView: UIView {
    static let height: CGFloat = 50

    private let titleLabel = UILabel()
    private let backgroundView = UIView()
    private let bottomGradientLayer = CAGradientLayer()
    private let gradientHeight: CGFloat = 2

    private let actionButton = UIButton()
    private var action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func set(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        titleLabel.text = title

        if let actionTitle = actionTitle {
            actionButton.setTitle(actionTitle, for: .normal)
            self.action = action
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }

    private func setUp() {
        backgroundColor = .clear

        backgroundView.backgroundColor = .clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -gradientHeight),
        ])

        bottomGradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
        ]
        layer.addSublayer(bottomGradientLayer)

        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        actionButton.setTitleColor(FolksamColor.Green1, for: .normal)
        actionButton.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            actionButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let origin = CGPoint(x: 0, y: backgroundView.bounds.height)
        let size = CGSize(width: backgroundView.bounds.width, height: gradientHeight)
        bottomGradientLayer.frame = CGRect(origin: origin, size: size)
    }

    @objc
    private func buttonAction() {
        action?()
    }
}
