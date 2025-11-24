import 'package:flutter/material.dart';
import 'login_register.dart';

// ---------------------------
// MAIN HOME PAGE
// ---------------------------
class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ---------------------------
  // USER STATE
  // ---------------------------
  String currentUser = "";
  List<Map<String, String>> users = [];

  // ---------------------------
  // TASK STATE
  // ---------------------------
  List<Map<String, dynamic>> tasks = [];
  String newTaskText = "";
  String selectedPriority = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // ---------------------------
        // SHOW LOGIN OR TODO PAGE
        // ---------------------------
        child: currentUser.isEmpty
            ? LoginRegisterWidget(
                users: users,
                onLogin: (username) {
                  setState(() {
                    currentUser = username;
                  });
                },
              )
            : buildTodoPage(),
      ),
    );
  }

  // ---------------------------
  // TODO PAGE
  // ---------------------------
  Widget buildTodoPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------------------
        // WELCOME MESSAGE
        // ---------------------------
        Text(
          "Welcome, $currentUser",
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
        ),
        const SizedBox(height: 10),

        // ---------------------------
        // LOGOUT BUTTON
        // ---------------------------
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            setState(() {
              currentUser = "";
              tasks = [];
            });
          },
          child: const Text("Logout"),
        ),
        const SizedBox(height: 20),

        // ---------------------------
        // NEW TASK INPUT
        // ---------------------------
        TextField(
          decoration: InputDecoration(
            labelText: "New Task",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            newTaskText = value;
          },
        ),
        const SizedBox(height: 10),

        // ---------------------------
        // PRIORITY DROPDOWN
        // ---------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: selectedPriority,
            isExpanded: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: "Low", child: Text("Low")),
              DropdownMenuItem(value: "Medium", child: Text("Medium")),
              DropdownMenuItem(value: "High", child: Text("High")),
            ],
            onChanged: (value) {
              setState(() {
                selectedPriority = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 10),

        // ---------------------------
        // ADD TASK BUTTON
        // ---------------------------
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (newTaskText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task cannot be empty")),
                );
                return;
              }
              setState(() {
                tasks.add({
                  "text": newTaskText,
                  "priority": selectedPriority,
                  "done": false
                });
                newTaskText = "";
              });
            },
            child: const Text(
              "Add Task",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ---------------------------
        // MARK ALL DONE / CLEAR ALL BUTTONS
        // ---------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  for (var task in tasks) {
                    task["done"] = true;
                  }
                });
              },
              child: const Text("Mark All Done"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  tasks.clear();
                });
              },
              child: const Text("Clear All"),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ---------------------------
        // TASK LIST TITLE
        // ---------------------------
        const Text("Your Tasks:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // ---------------------------
        // TASK LIST WITH DELETE BUTTON
        // ---------------------------
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Checkbox(
                    value: tasks[index]["done"],
                    onChanged: (value) {
                      setState(() {
                        tasks[index]["done"] = value!;
                      });
                    },
                  ),
                  title: Text(
                    tasks[index]["text"],
                    style: TextStyle(
                      color: getPriorityColor(tasks[index]["priority"]),
                      decoration: tasks[index]["done"]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text("Priority: ${tasks[index]["priority"]}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // ---------------------------
  // PRIORITY COLOR HELPER
  // ---------------------------
  Color getPriorityColor(String priority) {
    if (priority == "High") return Colors.red.shade700;
    if (priority == "Medium") return Colors.orange.shade700;
    return Colors.green.shade700;
  }
}
