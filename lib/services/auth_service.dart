import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> sendEmailCode(String email) async {
    await _client.auth.signInWithOtp(email: email.trim());
  }

  Future<void> sendPhoneCode(String phone) async {
    await _client.auth.signInWithOtp(phone: phone.trim());
  }

  Future<void> verifyEmailCode({required String email, required String token}) async {
    await _client.auth.verifyOTP(email: email.trim(), token: token.trim(), type: OtpType.email);
  }

  Future<void> verifyPhoneCode({required String phone, required String token}) async {
    await _client.auth.verifyOTP(phone: phone.trim(), token: token.trim(), type: OtpType.sms);
  }

  Future<void> ensureProfile({required String displayName, required String username}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Your session expired. Please sign in again.');
    final existing = await _client.from('apm_profiles').select('id').eq('id', user.id).maybeSingle();
    if (existing != null) return;
    await _client.from('apm_profiles').insert({
      'id': user.id,
      'display_name': displayName.trim(),
      'username': username.trim().toLowerCase(),
    });
  }

  Future<void> signOut() => _client.auth.signOut();
}
