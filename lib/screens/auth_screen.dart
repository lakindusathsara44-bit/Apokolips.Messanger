import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

enum _Method { email, phone }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayName = TextEditingController();
  final _username = TextEditingController();
  final _contact = TextEditingController();
  final _code = TextEditingController();
  final _auth = AuthService();
  _Method _method = _Method.email;
  bool _sent = false;
  bool _busy = false;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _displayName.dispose();
    _username.dispose();
    _contact.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; _message = null; });
    try {
      if (_method == _Method.email) {
        await _auth.sendEmailCode(_contact.text);
      } else {
        await _auth.sendPhoneCode(_contact.text);
      }
      if (!mounted) return;
      setState(() { _sent = true; _message = 'Verification code sent. Check your email or SMS.'; });
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_code.text.trim().length != 6) {
      setState(() => _error = 'Enter the 6-digit verification code.');
      return;
    }
    setState(() { _busy = true; _error = null; _message = null; });
    try {
      if (_method == _Method.email) {
        await _auth.verifyEmailCode(email: _contact.text, token: _code.text);
      } else {
        await _auth.verifyPhoneCode(phone: _contact.text, token: _code.text);
      }
      await _auth.ensureProfile(displayName: _displayName.text, username: _username.text);
      if (mounted) setState(() => _message = 'Verified. Your Apokolips account is ready.');
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendlyError(Object error) {
    final value = error.toString();
    if (value.toLowerCase().contains('duplicate') || value.toLowerCase().contains('unique')) {
      return 'That username is already taken. Choose another.';
    }
    if (value.contains('apm_profiles')) {
      return 'Profile setup is not ready. Run supabase/setup_profiles.sql first.';
    }
    return value.replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.bolt, color: AppTheme.cyan, size: 48),
                  const SizedBox(height: 16),
                  const Text('APOKOLIPS', textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.cyan, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 3)),
                  const SizedBox(height: 8),
                  const Text('Your conversations,\nunder your control.', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  const Text('Continue with your email address or phone number. A one-time code keeps sign-in passwordless.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppTheme.secondaryText, height: 1.5)),
                  const SizedBox(height: 28),
                  SegmentedButton<_Method>(
                    segments: const [
                      ButtonSegment(value: _Method.email, icon: Icon(Icons.email_outlined), label: Text('Email')),
                      ButtonSegment(value: _Method.phone, icon: Icon(Icons.phone_iphone), label: Text('Phone')),
                    ],
                    selected: {_method},
                    onSelectionChanged: _busy ? null : (values) => setState(() {
                      _method = values.first; _sent = false; _code.clear(); _error = null; _message = null;
                    }),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _displayName,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Display name', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your display name.' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _username,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.alternate_email),
                      helperText: '3–24 letters, numbers, or underscores'),
                    validator: (v) => RegExp(r'^[a-zA-Z0-9_]{3,24}$').hasMatch((v ?? '').trim())
                      ? null : 'Use 3–24 letters, numbers, or underscores.',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contact,
                    autocorrect: false,
                    keyboardType: _method == _Method.email ? TextInputType.emailAddress : TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: _method == _Method.email ? 'Email address' : 'Phone number (E.164)',
                      hintText: _method == _Method.email ? 'you@example.com' : '+947XXXXXXXX',
                      prefixIcon: Icon(_method == _Method.email ? Icons.email_outlined : Icons.phone_outlined),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (_method == _Method.email) {
                        return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)
                          ? null : 'Enter a valid email address.';
                      }
                      return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(value)
                        ? null : 'Use international format, e.g. +947XXXXXXXX.';
                    },
                  ),
                  if (_sent) ...[
                    const SizedBox(height: 12),
                    TextField(controller: _code, keyboardType: TextInputType.number, maxLength: 6,
                      decoration: const InputDecoration(labelText: '6-digit verification code', prefixIcon: Icon(Icons.lock_outline), counterText: '')),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                  ],
                  if (_message != null) ...[
                    const SizedBox(height: 12),
                    Text(_message!, style: const TextStyle(color: AppTheme.cyan)),
                  ],
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _busy ? null : (_sent ? _verify : _sendCode),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: AppTheme.accent),
                    child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_sent ? 'Verify and continue' : 'Send verification code'),
                  ),
                  if (_sent) TextButton(
                    onPressed: _busy ? null : () => setState(() { _sent = false; _code.clear(); _message = null; _error = null; }),
                    child: const Text('Change contact details'),
                  ),
                  const SizedBox(height: 14),
                  const Text('Use a contact method you control. Never share your verification code.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppTheme.secondaryText, fontSize: 11, height: 1.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
