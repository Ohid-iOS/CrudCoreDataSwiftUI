//
//  ContentView.swift
//  CrudCoreDataSwiftUI2
//
//  Created by MacMini6 on 28/01/25.


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NoteViewModel()
    @State private var showAddEditView = false
    @State private var selectedNote: Note?

    @State private var title: String = ""
    @State private var noteBody: String = "" // Renamed to avoid conflict
    @State private var isFavorite: Bool = false

    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(note.title ?? "Untitled")
                                .font(.headline)
                            Text(note.body ?? "No content")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        // Star icon that changes based on isFavorite
                        Image(systemName: note.isFavorite ? "star.fill" : "star")
                            .foregroundColor(note.isFavorite ? .yellow : .gray)
                    }
                    .onTapGesture {
                        selectedNote = note
                        title = note.title ?? ""
                        noteBody = note.body ?? "" // Updated to use noteBody
                        isFavorite = note.isFavorite
                        showAddEditView = true
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedNote = nil
                        title = ""
                        noteBody = "" // Updated to use noteBody
                        isFavorite = false
                        showAddEditView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddEditView) {
            NavigationView {
                Form {
                    TextField("Title", text: $title)
                    TextField("Body", text: $noteBody) // Updated to use noteBody
                    Toggle("Favorite", isOn: $isFavorite)
                    
                }
                .navigationTitle(selectedNote == nil ? "Add Note" : "Edit Note")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showAddEditView = false
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if let note = selectedNote {
                                viewModel.updateNote(note, title: title, body: noteBody, isFavorite: isFavorite)
                            } else {
                                viewModel.addNote(title: title, body: noteBody, isFavorite: isFavorite)
                            }
                            showAddEditView = false
                        }.disabled(title.isEmpty || noteBody.isEmpty)
                    }
                }
            }
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        offsets.map { viewModel.notes[$0] }.forEach(viewModel.deleteNote)
    }
}

#Preview {
    ContentView()
}
