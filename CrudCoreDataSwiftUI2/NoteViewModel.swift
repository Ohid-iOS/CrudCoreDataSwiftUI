//
//  ViewModel.swift
//  CrudCoreDataSwiftUI2
//
//  Created by MacMini6 on 28/01/25.
//

// NoteViewModel.swift

import Foundation
import CoreData

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchNotes()
    }

    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            notes = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error.localizedDescription)")
        }
    }

    func addNote(title: String, body: String, isFavorite: Bool) {
        let newNote = Note(context: viewContext)
        newNote.id = UUID()
        newNote.title = title
        newNote.body = body
        newNote.isFavorite = isFavorite
        newNote.createdAt = Date()

        saveContext()
        fetchNotes()
    }

    func updateNote(_ note: Note, title: String, body: String, isFavorite: Bool) {
        note.title = title
        note.body = body
        note.isFavorite = isFavorite
        saveContext()
        fetchNotes()
    }

    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        saveContext()
        fetchNotes()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
