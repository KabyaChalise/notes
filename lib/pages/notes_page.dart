import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/components/drawer.dart';
import 'package:notes/components/note_tile.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    // on app startup fetch the existing notes
    readNote();
  }

  // textcontroller
  final textController = TextEditingController();
  // Create a note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(),
              content: TextField(
                controller: textController,
              ),
              actions: [
                // create button
                MaterialButton(
                  onPressed: () {
                    // add to db
                    context.read<NoteDatabase>().addNote(textController.text);
                    // clear controller
                    textController.clear();
                    // pop the box
                    Navigator.pop(context);
                  },
                  child: const Text("Create"),
                )
              ],
            ));
  }

  // Read a note
  void readNote() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // Update a note
  void updateNote(Note note) {
    // pre fill the current note text
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(),
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text("Update Note"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                // update button
                MaterialButton(
                  onPressed: () {
                    // update note in db
                    context
                        .read<NoteDatabase>()
                        .updateNotes(note.id, textController.text);
                    // clear controller
                    textController.clear();
                    // pop box
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                )
              ],
            ));
  }

  // Delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // note database
    final noteDatabase = context.watch<NoteDatabase>();
    // current notes
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child:  Icon(
          color: Theme.of(context).colorScheme.inversePrimary,
          Icons.add,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              "Notes",
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  // get individual note
                  final notes = currentNotes[index];
                  // list tile ui
                  return NoteTile(
                    text: notes.text,
                    onEditPressed: () => updateNote(notes),
                    onDeletePressed: () => deleteNote(notes.id),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
