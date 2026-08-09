import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  const CrashlyticsService();

  Future<void> recordError(
    Object error,
    StackTrace stack,
  ) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
    );
  }

  void crash() {
    FirebaseCrashlytics.instance.crash();
  }
}