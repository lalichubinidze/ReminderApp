import Foundation

extension URL { var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName } }
