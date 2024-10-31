import 'package:flutter/material.dart';
import 'phone_login_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO
                Padding(
                  padding: EdgeInsets.only(bottom: 48.0),
                  child: FlutterLogo(size: 100),
                ),
                // Google 登入按鈕
                // ElevatedButton.icon(
                //   icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
                //   label: Text('使用 Google 帳號登入'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black87,
                //     elevation: 3,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 12),
                //   ),
                //   onPressed: () {
                //     Navigator.pushNamedAndRemoveUntil(context, '/swipe', (route) => false);
                //   },
                // ),
                // SizedBox(height: 16),
                // // Apple 登入按鈕
                // ElevatedButton.icon(
                //   icon: Icon(Icons.apple, color: Colors.white, size: 24),
                //   label: Text('使用 Apple 帳號登入'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.black87,
                //     foregroundColor: Colors.white,
                //     elevation: 3,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     padding: EdgeInsets.symmetric(vertical: 12),
                //   ),
                //   onPressed: () {
                //     // 實現 Apple 登入邏輯
                //   },
                // ),
                // SizedBox(height: 16),
                // 電話登入按鈕
                ElevatedButton.icon(
                  icon: Icon(Icons.phone, color: Colors.white, size: 24),
                  label: Text('使用電話號碼登入'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    // 實現電話登入邏輯或導航到電話登入頁面
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhoneLoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}