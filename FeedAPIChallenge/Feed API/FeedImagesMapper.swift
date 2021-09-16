//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Hardeep Singh on 15/09/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedImagesMapper {
	private init() {}

	private struct Root: Codable {
		let items: [Item]
		var images: [FeedImage] {
			items.map { $0.image }
		}
	}

	private struct Item: Codable {
		let image_id: UUID
		let image_url: URL
		let image_loc: String?
		let image_desc: String?

		var image: FeedImage {
			return FeedImage(id: image_id,
			                 description: image_desc,
			                 location: image_loc,
			                 url: image_url)
		}
	}

	private static var OK_200: Int { return 200 }

	static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		guard response.statusCode == OK_200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.images)
	}
}
