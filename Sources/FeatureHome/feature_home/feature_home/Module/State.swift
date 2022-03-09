//
//  State.swift
//  Home
//
//  Created by Johan Torell on 2021-02-24.
//

import Foundation
import ReSwift
import FolksamCommon

enum Actions {
    struct SetUser: Action {
        var user: ParentUser?
    }

    struct SetPolicies: Action {
        let policies: [Policy]
    }

    struct SetLoading: Action {}

    struct SetUserAndPolicies: Action {
        let user: ParentUser?
        let policies: [Policy]
    }
}

enum LoadState {
    case loading
    case ready
}

public struct HomeState {
    var user: ParentUser?
    var policies: [Policy]?
    var loadstate: LoadState = .loading
}

public protocol HasHomeState {
    var home: HomeState { get }
}

public func homeReducer(action: Action, state: HomeState?) -> HomeState {
    var state = state ?? HomeState()
    switch action {
    case let action as Actions.SetUser:
        state.user = action.user
    case let action as Actions.SetPolicies:
        state.policies = action.policies
    case _ as Actions.SetLoading:
        state.loadstate = .loading
    case let action as Actions.SetUserAndPolicies:
        state.loadstate = .ready
        state.user = action.user
        state.policies = action.policies
    default:
        break
    }
    return state
}
