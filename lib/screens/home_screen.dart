import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import 'add_note_screen.dart';
import 'login_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final notes = notesProvider.notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: notes.isEmpty
                ? const Center(child: Text("No notes available."))
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return ListTile(
                        title: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          note.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteDetailScreen(index: index),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
      ),
    );
  }
}
