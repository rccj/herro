import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              FlutterLogo(size: 100),
              SizedBox(height: 50),
              
              // Email input
              TextField(
                decoration: InputDecoration(
                  hintText: '電子郵件',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Password input
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '密碼',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 30),
              
              // Login button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/swipe');
                },
                child: Text('登入'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Register button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('還沒有帳號？立即註冊'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}