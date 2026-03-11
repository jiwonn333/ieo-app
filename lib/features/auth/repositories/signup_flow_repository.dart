import '../models/signup_step.dart';

abstract class SignupFlowRepository {
  Future<SignupStep?> getStep();

  Future<void> saveStep(SignupStep step);

  Future<void> clear();
}
