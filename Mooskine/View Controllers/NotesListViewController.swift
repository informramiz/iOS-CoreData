//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Ramiz on 07/12/2019.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    private var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var notebook: Notebook!
    private var listDataSource: ListDataSource<Note, NoteCell>!

    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupDataSource()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    private func setupDataSource() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let predicate = NSPredicate(format: "notebook == %@", notebook)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        listDataSource = ListDataSource<Note, NoteCell>(tableView: tableView, viewContext: dataController.viewContext, fetchRequest: fetchRequest, configureCell: { (cell, note) in
            // Configure cell
            cell.textPreviewLabel.text = note.text
            if let creationDate = note.creationDate {
                cell.dateLabel.text = self.dateFormatter.string(from: creationDate)
            }
        })
        listDataSource.onContentUpdated = {
            self.updateEditButtonState()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listDataSource = nil
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
        let note = Note(context: dataController.viewContext)
        note.notebook = notebook
        try? dataController.viewContext.save()
    }

    var isEditingPossible: Bool {
        return listDataSource.isEditingPossible
    }
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = isEditingPossible
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = listDataSource.object(at: indexPath)
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.listDataSource?.deleteItem(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
