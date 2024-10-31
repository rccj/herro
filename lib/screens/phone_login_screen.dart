import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String _selectedCountryCode = '+886'; // 預設台灣區碼
  bool _codeSent = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('手機號碼登入')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_codeSent) ...[
                DropdownButtonFormField<String>(
                  value: _selectedCountryCode,
                  items: ['+886'].map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text(code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryCode = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: '區碼'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: '手機號碼'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入手機號碼';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  child: Text('發送驗證碼'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final phoneNumber = '$_selectedCountryCode${_phoneController.text}';
                        print('Attempting to verify phone number: $phoneNumber');

                        await _auth.verifyPhoneNumber(
                          phoneNumber: phoneNumber,
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            print('Auto verification completed');
                            try {
                              await _auth.signInWithCredential(credential);
                              if (mounted) {
                                Navigator.pushReplacementNamed(context, '/swipe');
                              }
                            } catch (e) {
                              print('Error in verificationCompleted: $e');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('自動驗證失敗：$e')),
                                );
                              }
                            }
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            print('Verification failed: ${e.message}');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('驗證失敗：${e.message}')),
                              );
                            }
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            print('Verification code sent');
                            setState(() {
                              _verificationId = verificationId;
                              _codeSent = true;
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('驗證碼已發送')),
                              );
                            }
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            print('Auto retrieval timeout');
                            setState(() {
                              _verificationId = verificationId;
                            });
                          },
                          timeout: const Duration(seconds: 60),
                        );
                      } catch (e) {
                        print('Error during phone verification: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('發送驗證碼時發生錯誤：$e')),
                          );
                        }
                      }
                    }
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(labelText: '驗證碼'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入驗證碼';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  child: Text('驗證'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          verificationId: _verificationId!,
                          smsCode: _codeController.text,
                        );
                        
                        await _auth.signInWithCredential(credential);
                        
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/swipe');
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('驗證失敗：${e.message}')),
                        );
                      }
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
