//
//  PolicyRow.swift
//  feature_home
//
//  Created by Johan Torell on 2021-11-09.
//

import SwiftUI
import FolksamCommon

struct PolicyRow: View {
    var policy: Policy?
    let title: String
    let group: String?
    let premium: Int

    init(policy: Policy? = nil) {
        self.policy = policy
        title = policy?.product ?? ""
        group = policy?.groupName
        premium = policy?.premium ?? 0
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                if let group = group {
                    Text(group)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                if let premium = premium {
                    Text("Pris per år: \(premium) kr")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
}

struct PolicyRow_Previews: PreviewProvider {
    static var previews: some View {
        PolicyRow(policy: PolicyMock(policyId: "aaaa"))
    }
}

struct PolicyHeader: View {
    var body: some View {
        ZStack {
            HStack(alignment: .bottom) {
                Text("Mina försäkringar").font(.title)
                Spacer()
            }
            HStack {
                Spacer()
                Image(uiImage: UIImage(named: "risk", in: Bundle(for: FolksamButton.self), with: nil)!)
            }
        }
    }
}
