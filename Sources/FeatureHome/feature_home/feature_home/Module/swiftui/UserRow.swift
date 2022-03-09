//
//  UserRow.swift
//  feature_home
//
//  Created by Johan Torell on 2021-11-09.
//

import SwiftUI
import FolksamCommon

struct UserRow: View {
    let user: ParentUser

    var body: some View {
        Text(user.firstname ?? "")
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: UserMock())
    }
}
