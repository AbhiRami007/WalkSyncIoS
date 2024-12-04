//
//  DatabaseHelper.swift
//  WalkSync
//
//  Created by Abhirami Pradeep Susi on 2024-12-03.
//

import SQLite3
import Foundation

class DatabaseHelper: ObservableObject {
    var db: OpaquePointer?
    var dbPath: String = "userDatabase.sqlite"
    
    init() {
        self.db = createDatabase()
        createTable()
    }
    
    func createDatabase() -> OpaquePointer? {
        let filePath = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Failed to open database.")
            return nil
        }
        return db
    }
    
    func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            calorieIntake TEXT,
            weight TEXT,
            height TEXT,
            password TEXT
        );
        """
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Table created successfully.")
            } else {
                print("Failed to create table.")
            }
        } else {
            print("Failed to prepare table creation query.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertUser(name: String, email: String, calorieIntake: String, weight: String, height: String, password: String) -> Bool {
        let insertQuery = "INSERT INTO Users (name, email, calorieIntake, weight, height, password) VALUES (?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, name, -1, nil)
            sqlite3_bind_text(insertStatement, 2, email, -1, nil)
            sqlite3_bind_text(insertStatement, 3, calorieIntake, -1, nil)
            sqlite3_bind_text(insertStatement, 4, weight, -1, nil)
            sqlite3_bind_text(insertStatement, 5, height, -1, nil)
            sqlite3_bind_text(insertStatement, 6, password, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User inserted successfully.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Failed to insert user.")
            }
        } else {
            print("Insert statement preparation failed.")
        }
        sqlite3_finalize(insertStatement)
        return false
    }
    
    func checkEmailExists(email: String) -> Bool {
        let query = "SELECT * FROM Users WHERE email = ?;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, email, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                sqlite3_finalize(queryStatement)
                return true
            }
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    func validateUser(email: String, password: String) -> Bool {
        let query = "SELECT * FROM Users WHERE email = ? AND password = ?;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, email, -1, nil)
            sqlite3_bind_text(queryStatement, 2, password, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                sqlite3_finalize(queryStatement)
                return true // Valid user
            }
        }
        sqlite3_finalize(queryStatement)
        return false // Invalid user
    }

}
