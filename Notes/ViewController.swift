//
//  ViewController.swift
//  Notes
//
//  Created by MoHaMeD on 3/30/20.
//  Copyright © 2020 MoHaMeD. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes: [Note] = []
    @IBAction func createNote() {
        let _ = NoteManager.main.create()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
    
    func reload() {
        notes = NoteManager.main.getAllNotes()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            if let destination = segue.destination as?
                NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

