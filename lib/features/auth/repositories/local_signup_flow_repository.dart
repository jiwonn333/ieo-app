import 'package:shared_preferences/shared_preferences.dart';

import '../models/signup_step.dart';
import 'signup_flow_repository.dart';

class LocalSignupFlowRepository implements SignupFlowRepository {
  static const _key = 'signup_step';

  @override
  Future<SignupStep?> getStep() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return null;

    for (final step in SignupStep.values) {
      if (step.name == raw) {
        return step;
      }
    }
    return null;
  }

  @override
  Future<void> saveStep(SignupStep step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, step.name);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}