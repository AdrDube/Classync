//
//  UserModel.swift
//  login
//
//  Created by Njabulo Moyo on 3/30/25.
//

import Foundation

struct User: Codable {
    var firstName: String
    var lastName: String
    var gNumber: String
    var email: String
    var password: String
}

class LocalStorage {
    static let fileName = "users.json"

    static func getFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }

    static func saveUsers(_ users: [User]) {
        let filePath = getFilePath()
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: filePath)
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    static func loadUsers() -> [User] {
        let filePath = getFilePath()
        do {
            let data = try Data(contentsOf: filePath)
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Failed to load users: \(error)")
            return []
        }
    }
}
