// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let policyDetails = try? newJSONDecoder().decode(PolicyDetails.self, from: jsonData)

import FolksamCommon
import Foundation

// MARK: - PolicyDetails

struct PolicyDetailsMock: Codable {
    class Foo {}
    static var bundle: Bundle { return Bundle(for: PolicyDetailsMock.Foo.self) }

    static func load() -> PolicyDetailsMock {
        let data: PolicyDetailsMock = loadJSONFile("PolicyDetails.json", bundle: bundle)
        return data
    }

    let async: Bool
    let channel, server: JSONNull?
    let data: DataClass
}

// MARK: - DataClass

struct DataClass: Codable {
    let annualAmount: Int
    let adjustments: [Adjustment]
    let categoryCombinationCode, categoryCombinationDescription, groupName: String
    let groupProposal: JSONNull?
    let groupProposalFailed: Bool
    let insurances: [Insurance]
    let mainDueDate: String
    let paymentAmount: Int
    let paymentFrequency, paymentMethod, policyID, productTermCode: String
    let productTermDate: String
    let riskDescription: JSONNull?
    let startDate, status, versionDate: String
    let validToDate: JSONNull?
    let brandCode, brandText: String

    enum CodingKeys: String, CodingKey {
        case annualAmount, adjustments, categoryCombinationCode, categoryCombinationDescription, groupName, groupProposal, groupProposalFailed, insurances, mainDueDate, paymentAmount, paymentFrequency, paymentMethod
        case policyID = "policyId"
        case productTermCode, productTermDate, riskDescription, startDate, status, versionDate, validToDate, brandCode, brandText
    }
}

// MARK: - Adjustment

struct Adjustment: Codable {
    let adjustmentCode, adjustmentDescription: String
    let discounts: [Discount]
}

// MARK: - Discount

struct Discount: Codable {
    let code, codeDescription: String
    let discountAmount: Int
}

// MARK: - Insurance

struct Insurance: Codable {
    let coverages: [Coverage]
    let insuranceCode, insuranceDescription, rangeCode, rangeDescription: String
}

// MARK: - Coverage

struct Coverage: Codable {
    let code, codeDescription: String
    let deductibleAmount: Int
    let deductibleDescription: String
    let insuranceAmount: Int?
    let mandatoryCoverage: Bool
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    public static func == (_: JSONNull, _: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
