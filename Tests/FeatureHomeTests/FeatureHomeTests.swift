import Foundation
//@testable import Home
import ReSwift
import SnapshotTesting
import XCTest
import FolksamCommon
import FeatureHome

struct HomeUserMock: ParentUser {
    var email: String? = "ddadaw@dda.com"
    var telephone: String? = "0708111111"
    var customernumber: String? = "PFX-11234-AB"
    var firstname: String? = "Kurt"
    var surname: String? = "Wretman"
    var postalcode: String? = "22233"
    var street: String? = "SDAdD 30 "
    var subregion: String? = "ÅRsta"
}

struct HomeUserMockNil: ParentUser {
    var email: String?
    var telephone: String?
    var customernumber: String?
    var firstname: String?
    var surname: String?
    var postalcode: String?
    var street: String?
    var subregion: String?
}

struct PolicyMock: Policy {
    var insuredObject: String?
    var premium: Int?
    var premiumPeriod: String?
    var groupName: String?
    var policyId: String?
    var groupPolicyId: String?
    var product: String?
    var annullmentDate: String?
    var validToDate: String?
    var endedReasonText: String?
    var elements: [String]?
}

struct Failure: Error {}

class HomeServiceMock: HomeServiceProtocol {
    let fail: Bool
    let userMock = HomeUserMock()
    let policies = [PolicyMock(), PolicyMock()]

    init(fail: Bool) {
        self.fail = fail
    }

    func getUser(resultHandler: @escaping (Result<ParentUser, Error>) -> Void) {
        resultHandler(.success(userMock))
    }

    func getPolicies(resultHandler: @escaping (Result<[Policy], Error>) -> Void) {
        resultHandler(.success(policies))
    }

    func getUserAndPolicies(resultHandler: @escaping (Result<(ParentUser, [Policy]), Error>) -> Void) {
        if fail {
            resultHandler(.failure(Failure()))
        } else {
            resultHandler(.success((userMock, policies)))
        }
    }
}

struct State: StateType {
    let home: HomeState
}

extension State: HasHomeState {}

class Delegate: HomeDelegate {
    func homeViewController(didLogout _: UIViewController) {}
}

private func appReducer(action: Action, state: State?) -> State {
    return State(
        home: homeReducer(action: action, state: state?.home)
    )
}

class HomeTests: XCTestCase {
//    let movies: [Movie] = [
//            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
//            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2"),
//            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")
//    ]
//
    let store = Store<State>(reducer: appReducer, state: nil)
    override func setUp() {
        super.setUp()
//        isRecording = true
    }

    func test_shouldShowSpinner() {
        // given
        let vc = HomeViewController.make(apiService: HomeServiceMock(fail: true), store: store, delegate: Delegate())

        // then
        assertSnapshot(matching: vc, as: .image)
    }

    func test_shouldShowHome() {
        // given
        let vc = HomeViewController.make(apiService: HomeServiceMock(fail: false), store: store, delegate: Delegate())

        // then
        assertSnapshot(matching: vc, as: .image)
    }
//
//    func test_whenHasItems_thenShowItemsOnScreen() {
//        // given
//        let items = movies.map(MoviesListItemViewModel.init)
//        let vc = MoviesListViewController.create(
//            with: MoviesListViewModelMock.stub(items: Observable(items),
//                                               isEmpty: false,
//                                               emptyDataTitle: NSLocalizedString("Search results", comment: ""),
//                                               searchBarPlaceholder: NSLocalizedString("Search Movies", comment: "")
//            ),
//            posterImagesRepository: PosterImagesRepositoryMock())
//
//        // then
//        FBSnapshotVerifyView(vc.view)
//    }
    // }
//
//
    // struct MoviesListViewModelMock: MoviesListViewModel {
//    // MARK: - Input
//    func viewDidLoad() {}
//    func didLoadNextPage() {}
//    func didSearch(query: String) {}
//    func didCancelSearch() {}
//    func showQueriesSuggestions() {}
//    func closeQueriesSuggestions() {}
//    func didSelectItem(at index: Int) {}
//
//    // MARK: - Output
//    var items: Observable<[MoviesListItemViewModel]>
//    var loading: Observable<MoviesListViewModelLoading?>
//    var query: Observable<String>
//    var error: Observable<String>
//    var isEmpty: Bool
//    var screenTitle: String
//    var emptyDataTitle: String
//    var errorTitle: String
//    var searchBarPlaceholder: String
//
//    static func stub(items: Observable<[MoviesListItemViewModel]> = Observable([]),
//                     loading: Observable<MoviesListViewModelLoading?> = Observable(nil),
//                     query: Observable<String> = Observable(""),
//                     error: Observable<String> = Observable(""),
//                     isEmpty: Bool = true,
//                     screenTitle: String = NSLocalizedString("Movies", comment: ""),
//                     emptyDataTitle: String = NSLocalizedString("Search results", comment: ""),
//                     errorTitle: String = NSLocalizedString("Error", comment: ""),
//                     searchBarPlaceholder: String = NSLocalizedString("Search Movies", comment: "")) -> Self {
//        .init(items: items,
//              loading: loading,
//              query: query,
//              error: error,
//              isEmpty: isEmpty,
//              screenTitle: screenTitle,
//              emptyDataTitle: emptyDataTitle,
//              errorTitle: errorTitle,
//              searchBarPlaceholder: searchBarPlaceholder)
//    }
}
