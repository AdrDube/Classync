// ThemeManager.swift
//  Classync
//
//  Created by Praise Gavi on 4/5/25.
//
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { self.rawValue }
}
