import 'package:flutter/material.dart';

// ---------------------------
// LOGIN / REGISTER WIDGET
// ---------------------------
class LoginRegisterWidget extends StatefulWidget {
  final Function(String) onLogin;
  final List<Map<String, String>> users;

  const LoginRegisterWidget({super.key, required this.onLogin, required this.users});

  @override
  State<LoginRegisterWidget> createState() => _LoginRegisterWidgetState();
}

class _LoginRegisterWidgetState extends State<LoginRegisterWidget> {
  String loginUsername = "";
  String loginPassword = "";
  bool isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300, // limit width to stop stretching
        padding: const EdgeInsets.all(16), // smaller padding
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------
            // TITLE
            // ---------------------------
            Text(
              isLoginMode ? "Login" : "Register",
              style: const TextStyle(
                fontSize: 22, // smaller title
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 16), // smaller spacing

            // ---------------------------
            // USERNAME INPUT
            // ---------------------------
            SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  loginUsername = value;
                },
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------
            // PASSWORD INPUT
            // ---------------------------
            SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                obscureText: true,
                onChanged: (value) {
                  loginPassword = value;
                },
              ),
            ),

            const SizedBox(height: 16),

            // ---------------------------
            // LOGIN / REGISTER BUTTON
            // ---------------------------
            SizedBox(
              width: 150, // smaller width
              height: 40, // smaller height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (loginUsername.isEmpty || loginPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Username and password cannot be empty",
                        ),
                      ),
                    );
                    return;
                  }
                  if (isLoginMode) {
                    loginUser();
                  } else {
                    registerUser();
                  }
                },
                child: Text(
                  isLoginMode ? "Login" : "Register",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---------------------------
            // TOGGLE LOGIN / REGISTER
            // ---------------------------
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLoginMode = !isLoginMode;
                  });
                },
                child: Text(
                  isLoginMode
                      ? "Create account"
                      : "Already have an account? Login",
                  style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // REGISTER FUNCTION
  // ---------------------------
  void registerUser() {
    widget.users.add({
      "username": loginUsername,
      "password": loginPassword,
    });

    setState(() {
      isLoginMode = true;
    });
  }

  // ---------------------------
  // LOGIN FUNCTION
  // ---------------------------
  void loginUser() {
    for (var user in widget.users) {
      if (user["username"] == loginUsername &&
          user["password"] == loginPassword) {
        widget.onLogin(loginUsername);
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Incorrect username or password")),
    );
  }
}
