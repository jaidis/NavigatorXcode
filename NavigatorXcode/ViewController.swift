//
//  ViewController.swift
//  NavigatorXcode
//
//  Created by Manuel Muñoz on 17/1/19.
//  Copyright © 2019 Manuel Muñoz. All rights reserved.
//

import UIKit
import WebKit
import SQLite3

class ViewController: UIViewController {

    @IBOutlet weak var tf_Url: UITextField!
    @IBOutlet var wv_Navegador: WKWebView!
    
    @IBAction func bt_Atras(_ sender: Any) {
        wv_Navegador.goBack()
    }
    @IBAction func bt_Avanzar(_ sender: Any) {
        wv_Navegador.goForward()
    }
    @IBAction func bt_Buscar(_ sender: Any) {
        cargarUrl()
    }
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tf_Url.text = "https://www.google.es"
        cargarUrl()
        
        // Cargar Base de Datos local
        
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
    }
    
    func cargarUrl(){
        let myurl = URL(string: tf_Url.text!)!
        wv_Navegador.load(URLRequest(url: myurl))
        wv_Navegador.allowsBackForwardNavigationGestures = true
        wv_Navegador.allowsLinkPreview = true
        
        //Guarda la web visitada en la Base de Datos
        insertarDatos()
    }
    
    func insertarDatos(){
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO HISTORY ('url') VALUES ('"+tf_Url.text!+"')"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }

    }


}

