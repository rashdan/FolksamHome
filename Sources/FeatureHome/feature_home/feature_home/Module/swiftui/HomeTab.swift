//
//  HomeTab.swift
//  feature_home
//
//  Created by Johan Torell on 2021-11-09.
//

import SwiftUI
import FolksamCommon

public struct HomeTab: View {
    private struct PrivateState {
        var user: ParentUser? = nil
        var policies: [Policy]? = nil
        var isLoading: Bool = true
    }

    @State private var state = PrivateState()

    var apiService: HomeServiceProtocol

    func fetchData() {
        apiService.getUserAndPolicies { [self] result in
            switch result {
            case let .failure(error):
                print(error)
            case .success(let (user, policies)):
                self.state = PrivateState(user: user, policies: policies, isLoading: false)
            }
        }
    }

    public init(apiService: HomeServiceProtocol) {
        self.apiService = apiService
    }

    public var body: some View {
        NavigationView {
            if !state.isLoading, let user = state.user, let policies = state.policies {
                FolksamList {
                    Section {
                        Text("\(state.user?.customernumber ?? "")\n\(state.user?.firstname ?? "") \(state.user?.surname ?? "")\n\(state.user?.street ?? "") \(state.user?.postalcode ?? "") \(state.user?.subregion ?? "")")
                    }
                    Section(header: PolicyHeader()) {
                        ForEach(Array(zip(policies.indices, policies)), id: \.1.policyId) { index, policy in
                            let color = index % 2 == 0 ? Color(FolksamColor.beige3) : .white
                            NavigationLink {
                                PolicyDetails()
                            } label: {
                                PolicyRow(policy: policy)
                            }
                            .padding([.top, .bottom], 10)
                            .listRowBackground(color)
                        }
                    }
                }
                .padding([.top], 0.5) // need padding to not overlap navbar TODO: examine and test on all ios versions
                .navigationBarTitle("Hej \(user.firstname?.capitalizingFirstLetter() ?? "")!")
                .navigationBarItems(trailing: Button("Logga ut", action: {}))
            } else {
                ActivityIndicator(isAnimating: $state.isLoading, style: .large)
            }
        }
        .onAppear(perform: fetchData) // TODO: fetches every time tab is pressed
    }
}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab(apiService: HomeServiceMock())
    }
}
