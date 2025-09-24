import 'package:flutter/material.dart';

// Model class untuk Task
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});

  void toggle() {
    isCompleted = !isCompleted;
  }

  @override
  String toString() {
    return 'Task{title: $title, isCompleted: $isCompleted}';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App Pemula',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController taskController = TextEditingController();
  final List<Task> tasks = [];

  // Tambah task baru
  void _addTask() {
    String newTaskTitle = taskController.text.trim();

    if (newTaskTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task tidak boleh kosong!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    bool isDuplicate = tasks.any(
      (task) => task.title.toLowerCase() == newTaskTitle.toLowerCase(),
    );

    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "$newTaskTitle" sudah ada!'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (newTaskTitle.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task terlalu panjang! Maksimal 100 karakter.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      tasks.add(Task(title: newTaskTitle));
    });

    taskController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "$newTaskTitle" berhasil ditambahkan!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Hapus task
  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Toggle selesai/belum
  void _toggleTask(int index) {
    setState(() {
      tasks[index].toggle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input
            TextField(
              controller: taskController,
              maxLength: 100,
              decoration: const InputDecoration(
                hintText: 'Ketik task baru di sini...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _addTask(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('Belum ada task'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        Task task = tasks[index];
                        return ListTile(
                          leading: IconButton(
                            icon: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleTask(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeTask(index),
                          ),
                          onTap: () => _toggleTask(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}