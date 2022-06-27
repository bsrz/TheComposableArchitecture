import Foundation

struct Todo: Identifiable, Equatable {
    var id: UUID = .init()
    var description = ""
    var isComplete = false
}
