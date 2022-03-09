//
//  PolicyDetails.swift
//  feature_home
//
//  Created by Johan Torell on 2021-11-10.
//

import SwiftUI

struct PolicyDetails: View {
    let policyDetails: PolicyDetailsMock

    init() {
        policyDetails = PolicyDetailsMock.load()
    }

    var body: some View {
        Text(policyDetails.data.categoryCombinationDescription)
    }
}

struct PolicyDetails_Previews: PreviewProvider {
    static var previews: some View {
        PolicyDetails()
    }
}
