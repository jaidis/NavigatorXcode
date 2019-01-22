//
//  ViewController2.swift
//  NavigatorXcode
//
//  Created by Manuel Muñoz on 18/1/19.
//  Copyright © 2019 Manuel Muñoz. All rights reserved.
//

import UIKit
import SQLite3

class ViewController2: UIViewController {
    var db: OpaquePointer?
    var list: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("NavigatorXcode.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS HISTORY (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        
        //this is our select query
        let queryString = "SELECT * FROM HISTORY ORDER BY id DESC LIMIT 10"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //let id = sqlite3_column_int(stmt, 0)
            let url = String(cString: sqlite3_column_text(stmt, 1))
            list.append(url)
        }
        
        for elemento in list {
            print(elemento)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
