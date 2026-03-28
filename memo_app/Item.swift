import Foundation
import SwiftData

@Model
final class Memo {
    var content: String
    var createdAt: Date
    var isFavorite: Bool

    init(content: String = "", createdAt: Date = .now, isFavorite: Bool = false) {
        self.content = content
        self.createdAt = createdAt
        self.isFavorite = isFavorite
    }
}
