import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '', userType = 'jobseeker';
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) => val!.length < 6 ? 'Password too short' : null,
              ),
              DropdownButtonFormField(
                value: userType,
                items: [
                  DropdownMenuItem(value: 'jobseeker', child: Text('Job Seeker')),
                  DropdownMenuItem(value: 'employer', child: Text('Employer')),
                ],
                onChanged: (val) => setState(() => userType = val as String),
                decoration: InputDecoration(labelText: 'Register as'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    try {
                      await AuthService().register(email, password, userType);
                      Navigator.pop(context); // Go back to login or home
                    } catch (e) {
                      setState(() => error = e.toString());
                    }
                    setState(() => loading = false);
                  }
                },
                child: loading ? CircularProgressIndicator() : Text('Register'),
              ),
              if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}