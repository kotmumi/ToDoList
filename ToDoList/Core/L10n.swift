//
//  L10n.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 28.02.26.
//

import Foundation

enum L10n {
    static var title: String { String(localized: "title") }
    static var countTasks: String { String(localized: "countTasks")}
    static var searchPlaceholder: String { String(localized: "placeholder")}
    static var titlePlaceholder: String { String(localized: "placeholderTitle")}
    static var descriptionPlaceholder: String { String(localized: "placeholderDescription")}
    static var save: String { String(localized: "save") }
    static var cancel: String { String(localized: "cancel") }
    static var titleRequired: String { String(localized: "titleRequired") }
    static var back: String { String(localized: "back") }
    static var edit: String { String(localized: "edit") }
    static var share: String { String(localized: "share") }
    static var delete: String { String(localized: "delete") }
    static var ok: String { String(localized: "ok") }
    
    static var errorNoInternet: String { String(localized: "errorNoInternet") }
    static var errorNetwork: String { String(localized: "errorNetwork") }
    static var errorNoData: String { String(localized: "errorNoData") }
    static var errorDecoding: String { String(localized: "errorDecoding") }
    static var errorStorage: String { String(localized: "errorStorage") }
    static var errorTaskNotFound: String { String(localized: "errorTaskNotFound") }
    static var errorUnknown: String { String(localized: "errorUnknown") }
}
