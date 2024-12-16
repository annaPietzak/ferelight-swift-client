import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

public class FereLightClient {
    let client: Client
    
    /// Instantiate client and perform login.
    public init(url: URL) async throws {
        self.client = Client(serverURL: url, transport: URLSessionTransport())
    }
    
    /// Retrieves object information for the specified object ID.
    ///
    /// - Parameters:
    ///   - objectId: The ID of the object to retrieve info for.
    ///
    /// - Returns: Object information.
    public func getObjectInfo(objectId: String) async throws -> (objectId: String, mediaType: Int, name: String, path: String) {
        let response = try await client.get_sol_objectinfo_sol__lcub_objectid_rcub_(path: .init(objectid: objectId))
        
        let message = try response.ok.body.json
        
        return (message.objectid!, message.mediatype!, message.name!, message.path!)
    }
    
    /// Retrieves segment information for the specified segment ID.
    ///
    /// - Parameters:
    ///   - segmentId: The ID of the segment to retrieve info for.
    ///
    /// - Returns: Segment information.
    public func getSegmentInfo(segmentId: String) async throws -> (segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double) {
        let response = try await client.get_sol_segmentinfo_sol__lcub_segmentid_rcub_(path: .init(segmentid: segmentId))
        
        let message = try response.ok.body.json
        
        return (message.segmentid!, message.objectid!, message.segmentnumber!, message.segmentstart!, message.segmentend!, message.segmentstartabs!, message.segmentendabs!)
    }
    
    /// Retrieves all segments of the multimedia object with the specified objectID.
    ///
    /// - Parameters:
    ///   - objectId: The ID of the object to retrieve segments for.
    ///
    /// - Returns: Array of segment infos of the segments in the object.
    public func getObjectSegments(objectId: String) async throws -> [(segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double)] {
        let response = try await client.get_sol_objectsegments_sol__lcub_objectid_rcub_(path: .init(objectid: objectId))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.objectid!, $0.segmentnumber!, $0.segmentstart!, $0.segmentend!, $0.segmentstartabs!, $0.segmentendabs!) }
    }
    
    /// Retrieves object information for the specified object IDs.
    ///
    /// - Parameters:
    ///   - objectIds: The IDs of the objects to retrieve info for.
    ///
    /// - Returns: Object information array.
    public func getObjectInfos(objectIds: [String]) async throws -> [(objectId: String, mediaType: Int, name: String, path: String)] {
        let response = try await client.post_sol_objectinfos(body: .json(.init(objectids: objectIds)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.objectid!, $0.mediatype!, $0.name!, $0.path!) }
    }
    
    /// Retrieves segment information for the specified segment IDs.
    ///
    /// - Parameters:
    ///   - segmentIds: The IDs of the segments to retrieve info for.
    ///
    /// - Returns: Segment information array.
    public func getSegmentInfos(segmentIds: [String]) async throws -> [(segmentId: String, objectId: String, segmentNumber: Int, segmentStart: Int, segmentEnd: Int, segmentStartAbs: Double, segmentEndAbs: Double)] {
        let response = try await client.post_sol_segmentinfos(body: .json(.init(segmentids: segmentIds)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.objectid!, $0.segmentnumber!, $0.segmentstart!, $0.segmentend!, $0.segmentstartabs!, $0.segmentendabs!) }
    }
    
    /// Queries the database with the given similarity text, ocr text, and results limit.
    ///
    /// - Parameters:
    ///   - similarityText: Text to use for nearest neighbor search based on a semantic embedding.
    ///   - ocrText: Text to use for a filtering text search.
    ///   - limit: Maximum number of results to return.
    ///
    /// - Returns: Array of segment ID and similarity score pairs.
    public func query(similarityText: String?, ocrText: String?, limit: Int?) async throws -> [(segmentId: String, score: Double)] {
        let response = try await client.post_sol_query(body: .json(.init(similaritytext: similarityText, ocrtext: ocrText, limit: limit)))
        
        let message = try response.ok.body.json
        
        return message.map { ($0.segmentid!, $0.score!) }
    }
}
