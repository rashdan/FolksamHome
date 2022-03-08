//
//  HomeViewController.swift
//  FolksamApp
//
//  Created by Johan Torell on 2021-01-28.
//

import ReSwift
import UIKit
import FolksamCommon

public protocol HomeDelegate: AnyObject {
    func homeViewController(didLogout from: UIViewController)
}

public class HomeViewController<S: StoreType>: UIViewController where S.State: HasHomeState {
    // set state type for correct inferred type
    public typealias StoreSubscriberStateType = HomeState

    @IBOutlet var loadingView: UIView!
    @IBOutlet var nameLabel: UILabel!

    private var apiService: HomeServiceProtocol!
    private var store: S!
    private var delegate: HomeDelegate!
    private var tableViewController: HomeTableViewController!

    // MARK: - Life cycle

    override public func viewWillAppear(_: Bool) {
        store.subscribe(self) {
            $0.select { $0.home }
        }
    }

    override public func viewWillDisappear(_: Bool) {
        store.unsubscribe(self)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = .init(title: "Logga ut", style: .done, target: self, action: #selector(logout))
        fetchData()
    }

    deinit {
        delegate = nil
    }

    // MARK: - Factory

    public static func make(apiService: HomeServiceProtocol, store: S, delegate: HomeDelegate) -> UINavigationController {
        let storyboard = UIStoryboard(name: "HomeTab", bundle: Bundle.module)
        if #available(iOS 13.0, *) {
            let (nav, vc) = storyboard.instantiateWithNavigationController(childOfType: HomeViewController.self, creator: { HomeViewController(coder: $0, store: store)! })
            vc.apiService = apiService
            vc.store = store
            print(delegate)
            vc.delegate = delegate
            nav.tabBarItem = UITabBarItem(title: "Hem", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
            return nav
        } else {
            return UINavigationController()
            // Fallback on earlier versions
            // TODO: HOW? Instantiate a generic viewcontroller from storyboard
        }
    }

    // MARK: - Selector Actions

    @objc func logout() {
        delegate.homeViewController(didLogout: self)
    }

    // MARK: - Methods

    private func fetchData() {
        apiService.getUserAndPolicies { [weak self] result in
            guard let self = self else { return }
            self.store.dispatch(Actions.SetLoading())
            switch result {
            case let .failure(error):
                print(error)
            case .success(let (user, policies)):
                self.store.dispatch(Actions.SetUserAndPolicies(user: user, policies: policies))
            }
        }
    }

    override public func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let vc = segue.destination as? HomeTableViewController {
            tableViewController = vc
            vc.delegate = self
        }
    }

    // MARK: - INITS needed for initialising generic viewcontroller from storyboard

    init?(coder: NSCoder, store: S) {
        self.store = store
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("use make(coder:store:) instead") }
}

// MARK: - STATE RENDER

extension HomeViewController: StoreSubscriber {
    public func newState(state: HomeState) {
        switch state.loadstate {
        case .loading:
            loadingView.alpha = 1
        case .ready:
            if let policies = state.policies, let user = state.user {
                loadingView.alpha = 0
                tableViewController.setData(user: user, policies: policies)
            }
        }
    }
}

extension HomeViewController: HomeTableDelegate {}
