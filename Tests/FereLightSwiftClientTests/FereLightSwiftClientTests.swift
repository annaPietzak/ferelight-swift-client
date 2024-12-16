import Testing
import Foundation
@testable import FereLightSwiftClient

let host = "http://localhost"
let port = "8080"
let testObjectId = "v_09905"
let testObjectIds = [testObjectId, "v_09906"]
let testSegmentId = "v_09905_1"
let testSegmentIds = [testSegmentId, "v_09906_1", "v_09906_2"]
let testSimilarityText = "A dog running through a field"
let testOcrText = "cabbage"
let testResultsLimit = 10


@Test func getObjectInfo() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectInfo(objectId: testObjectId)
    let objectName = "\(testObjectId.dropFirst(2)).mp4"
    #expect(result.objectId == testObjectId)
    #expect(result.name == objectName)
}

@Test func getSegmentInfo() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getSegmentInfo(segmentId: testSegmentId)
    #expect(result.objectId == testObjectId)
    #expect(result.segmentId == testSegmentId)
}

@Test func getObjectSegments() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectSegments(objectId: testObjectId)
    #expect(result.count > 0)
    #expect(result.first?.objectId == testObjectId)
}

@Test func getObjectInfos() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getObjectInfos(objectIds: testObjectIds)
    #expect(result.count == testObjectIds.count)
}

@Test func getSegmentInfos() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.getSegmentInfos(segmentIds: testSegmentIds)
    #expect(result.count == testSegmentIds.count)
}

@Test func similarityQuery() async throws {
    let client = try await FereLightClient(url: URL(string: host + ":" + port)!)
    let result = try await client.query(similarityText: testSimilarityText, ocrText: nil, limit: testResultsLimit)
    #expect(result.count == testResultsLimit)
}
