import 'package:flutter/material.dart';
import '../widgets/avatar_selector.dart';
import '../widgets/password_strength.dart';
import '../widgets/progress_tracker.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _dob = TextEditingController();
  final _authService = AuthService();
  bool _visible = false;
  bool _loading = false;
  int _avatarIndex = 0;

  double get _progress {
    int filled = 0;
    if (_name.text.isNotEmpty) filled++;
    if (_email.text.isNotEmpty) filled++;
    if (_dob.text.isNotEmpty) filled++;
    if (_password.text.isNotEmpty) filled++;
    return (filled / 4).clamp(0.0, 1.0);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob.text = "${picked.day}/${picked.month}/${picked.year}");
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      
      try {
        await _authService.registerWithEmailAndPassword(
          _email.text.trim(),
          _password.text,
        );
        
        setState(() => _loading = false);

        final badges = <String>[];
        if (_password.text.length >= 10 && RegExp(r'[A-Z]').hasMatch(_password.text)) {
          badges.add('Strong Password Master');
        }
        if (DateTime.now().hour < 12) badges.add('The Early Bird Special');
        if (_progress >= 1.0) badges.add('Profile Completer');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              userName: _name.text,
              avatarIndex: _avatarIndex,
              badges: badges,
            ),
          ),
        );
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (var c in [_name, _email, _password, _dob]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Account 🎉')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProgressTracker(progress: _progress),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Adventure Name',
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter a name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  ),
                  validator: (v) =>
                      v!.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dob,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
                  ),
                  validator: (v) => v!.isEmpty ? 'Pick a date' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: !_visible,
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _visible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () => setState(() => _visible = !_visible),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? 'At least 6 chars' : null,
                ),
                const SizedBox(height: 8),
                PasswordStrength(password: _password.text),
                const SizedBox(height: 12),
                AvatarSelector(onSelected: (i) => setState(() => _avatarIndex = i)),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Start My Adventure', style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
