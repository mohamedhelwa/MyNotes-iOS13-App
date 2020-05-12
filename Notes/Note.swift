//
//  Note.swift
//  Notes
//
//  Created by MoHaMeD on 3/30/20.
//  Copyright © 2020 MoHaMeD. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
}

class NoteManager {
    var database: OpaquePointer!
    
    static let main = NoteManager()
    
    private init() {
    }
    
    func connect() {
        if database != nil {
            return
        }
        
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT)", nil, nil, nil) == SQLITE_OK {
                    
                }
                else {
                    print("Could not create table!")
                }
            }
            else {
                print("Could not connect to your database!")
            }
        }
        catch let error {
            print("Could not create database to safe your notes!")
        }
    }
    
    func create() -> Int {
        connect()
        
        var statment: OpaquePointer!
        if sqlite3_prepare_v2(database, "INSERT INTO notes (contents) VALUES ('New note')", -1, &statment, nil) != SQLITE_OK {
            print("Could not create query!")
            return -1
        }
        
        if sqlite3_step(statment) != SQLITE_DONE {
            print("Could not insert note!")
            return -1
        }
        
        sqlite3_finalize(statment)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllNotes() -> [Note] {
        connect()
        var result: [Note] = []
        
        var statment: OpaquePointer!
        if sqlite3_prepare_v2(database, "SELECT rowid, contents FROM notes", -1, &statment, nil) != SQLITE_OK {
            print("Error creating SELECT!")
            return []
        }
        
        while sqlite3_step(statment) == SQLITE_ROW{
            result.append(Note(id: Int(sqlite3_column_int(statment, 0)), contents: String(cString: sqlite3_column_text(statment, 1))))
        }
        
        sqlite3_finalize(statment)
        return result
    }
    
    func save(note: Note) {
        connect()
        var statment: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ? WHERE rowid = ?", -1, &statment, nil) != SQLITE_OK {
            print("Error creating UPDATE statment!")
        }
        
        sqlite3_bind_text(statment, 1, NSString(string: note.contents).utf8String, -1, nil)
        sqlite3_bind_int(statment, 2, Int32(note.id))
        
        if sqlite3_step(statment) != SQLITE_DONE {
            print("Error running UPDATE statment!")
        }
        
        sqlite3_finalize(statment)
    }
}
