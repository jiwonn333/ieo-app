import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final kakaoKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
  if (kakaoKey == null || kakaoKey.isEmpty) {
    throw Exception('KAKAO_NATIVE_APP_KEY가 .env에 설정되지 않았습니다.');
  }
  KakaoSdk.init(nativeAppKey: kakaoKey);

  runApp(const ProviderScope(child: IeoApp()));
}
