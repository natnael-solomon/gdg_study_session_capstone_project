warning: in the working copy of 'capstone/linux/flutter/generated_plugin_registrant.cc', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/linux/flutter/generated_plugin_registrant.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/linux/flutter/generated_plugins.cmake', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/macos/Flutter/GeneratedPluginRegistrant.swift', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/windows/flutter/generated_plugin_registrant.cc', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/windows/flutter/generated_plugin_registrant.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'capstone/windows/flutter/generated_plugins.cmake', LF will be replaced by CRLF the next time Git touches it
[1mdiff --git a/capstone/lib/auth/auth_service.dart b/capstone/lib/auth/auth_service.dart[m
[1mindex 236bf54..83fdec3 100644[m
[1m--- a/capstone/lib/auth/auth_service.dart[m
[1m+++ b/capstone/lib/auth/auth_service.dart[m
[36m@@ -10,9 +10,22 @@[m [mclass AuthException implements Exception {[m
 }[m
 [m
 class AuthService {[m
[32m+[m[32m  static final AuthService _instance = AuthService._internal();[m
[32m+[m
[32m+[m[32m  factory AuthService() => _instance;[m
[32m+[m
[32m+[m[32m  AuthService._internal() {[m
[32m+[m[32m    _auth.authStateChanges().listen((User? user) {[m
[32m+[m[32m      _currentUser = user;[m
[32m+[m[32m    });[m
[32m+[m[32m  }[m
[32m+[m
   final FirebaseAuth _auth = FirebaseAuth.instance;[m
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;[m
 [m
[32m+[m[32m  User? _currentUser;[m
[32m+[m[32m  User? get currentUser => _currentUser;[m
[32m+[m
   Future<void> signUp({[m
     required String username,[m
     required String email,[m
[36m@@ -23,7 +36,6 @@[m [mclass AuthService {[m
     try {[m
       final normalizedUsername = username.toLowerCase();[m
 [m
[31m-      [m
       final usernameDoc =[m
           await _firestore[m
               .collection('usernames')[m
[36m@@ -34,7 +46,6 @@[m [mclass AuthService {[m
         throw AuthException('Username already taken');[m
       }[m
 [m
[31m-      [m
       final userCredential = await _auth.createUserWithEmailAndPassword([m
         email: email,[m
         password: password,[m
[36m@@ -49,7 +60,6 @@[m [mclass AuthService {[m
         'uid': uid,[m
       });[m
 [m
[31m-     [m
       batch.set(_firestore.collection('users').doc(uid), {[m
         'username': normalizedUsername,[m
         'email': email,[m
[36m@@ -64,27 +74,24 @@[m [mclass AuthService {[m
       if (photoUrl != null && photoUrl.isNotEmpty) {[m
         await userCredential.user!.updatePhotoURL(photoUrl);[m
       }[m
[32m+[m
[32m+[m[32m      _currentUser = userCredential.user;[m
     } on FirebaseAuthException catch (e) {[m
       throw AuthException(_getAuthErrorMessage(e));[m
     } on FirebaseException catch (e) {[m
       throw AuthException(_getFirestoreErrorMessage(e));[m
     } catch (e) {[m
[31m-      throw AuthException('An unexpected error occurred: ${e.toString()}');[m
[32m+[m[32m      throw AuthException([m
[32m+[m[32m        'Registration failed. Please try again.',[m
[32m+[m[32m      );[m[41m [m
     }[m
   }[m
 [m
   Future<void> signIn(String username, String password) async {[m
     try {[m
       final normalizedUsername = username.toLowerCase();[m
[31m-      final doc =[m
[31m-          await _firestore[m
[31m-              .collection('usernames')[m
[31m-              .doc(normalizedUsername)[m
[31m-              .get();[m
 [m
[31m-      if (!doc.exists) throw AuthException('Username not found');[m
[31m-[m
[31m-      final email = doc['email'] as String;[m
[32m+[m[32m      final email = await _getEmailForUsername(normalizedUsername);[m
 [m
       await _auth.signInWithEmailAndPassword(email: email, password: password);[m
     } on FirebaseAuthException catch (e) {[m
[36m@@ -92,34 +99,73 @@[m [mclass AuthService {[m
     } on FirebaseException catch (e) {[m
       throw AuthException(_getFirestoreErrorMessage(e));[m
     } catch (e) {[m
[31m-      throw AuthException('An unexpected error occurred: ${e.toString()}');[m
[32m+[m[32m      throw AuthException([m
[32m+[m[32m        'Login failed. Please try again.',[m
[32m+[m[32m      );[m[41m [m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Future<String> _getEmailForUsername(String username) async {[m
[32m+[m[32m    try {[m
[32m+[m[32m      final doc = await _firestore.collection('usernames').doc(username).get();[m
[32m+[m
[32m+[m[32m      if (doc.exists) {[m
[32m+[m[32m        return doc['email'] as String;[m
[32m+[m[32m      }[m
[32m+[m[32m      /*a dummy email if username doesn't exist to prevent enumeration*/[m
[32m+[m[32m      return 'invalid_${DateTime.now().millisecondsSinceEpoch}@dummy.com';[m
[32m+[m[32m    } catch (e) {[m
[32m+[m[32m      throw AuthException('Login service unavailable');[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Future<void> signOut() async {[m
[32m+[m[32m    try {[m
[32m+[m[32m      await _auth.signOut();[m
[32m+[m[32m      _currentUser = null;[m
[32m+[m[32m    } catch (e) {[m
[32m+[m[32m      throw AuthException('Could not sign out. Please try again.');[m
     }[m
   }[m
 [m
[32m+[m[32m  Stream<User?> get authStateChanges => _auth.authStateChanges();[m
[32m+[m
   String _getAuthErrorMessage(FirebaseAuthException e) {[m
     switch (e.code) {[m
       case 'email-already-in-use':[m
[31m-        return 'Email is already in use.';[m
[32m+[m[32m        return 'An account with this email already exists';[m
       case 'weak-password':[m
[31m-        return 'Password is too weak.';[m
[32m+[m[32m        return 'Password must be at least 6 characters';[m
       case 'invalid-email':[m
[31m-        return 'Invalid email address.';[m
[32m+[m[32m        return 'Please enter a valid email address';[m
       case 'wrong-password':[m
[31m-        return 'Incorrect password.';[m
       case 'user-not-found':[m
[31m-        return 'User not found.';[m
[32m+[m[32m        return 'Invalid credentials';[m[41m [m
[32m+[m[32m      case 'user-disabled':[m
[32m+[m[32m        return 'This account has been disabled. Contact support';[m
[32m+[m[32m      case 'operation-not-allowed':[m
[32m+[m[32m        return 'Login is currently unavailable. Try again later';[m
[32m+[m[32m      case 'too-many-requests':[m
[32m+[m[32m        return 'Too many attempts. Please try again later';[m
[32m+[m[32m      case 'network-request-failed':[m
[32m+[m[32m        return 'Network error. Please check your connection';[m
       default:[m
[31m-        return 'Authentication failed: ${e.message}';[m
[32m+[m[32m        return 'Invalid credentials';[m[41m [m
     }[m
   }[m
 [m
   String _getFirestoreErrorMessage(FirebaseException e) {[m
[31m-    return 'Database operation failed: ${e.message}';[m
[31m-  }[m
[31m-[m
[31m-  User? get currentUser => _auth.currentUser;[m
[31m-[m
[31m-  Future<void> signOut() async {[m
[31m-    await _auth.signOut();[m
[32m+[m[32m    switch (e.code) {[m
[32m+[m[32m      case 'permission-denied':[m
[32m+[m[32m        return 'Operation not permitted';[m
[32m+[m[32m      case 'unavailable':[m
[32m+[m[32m        return 'Service unavailable. Try again later';[m
[32m+[m[32m      case 'aborted':[m
[32m+[m[32m        return 'Operation aborted';[m
[32m+[m[32m      case 'data-loss':[m
[32m+[m[32m        return 'Data loss occurred';[m
[32m+[m[32m      default:[m
[32m+[m[32m        return 'Database operation failed. Please try again';[m
[32m+[m[32m    }[m
   }[m
 }[m
[1mdiff --git a/capstone/lib/auth/login_page.dart b/capstone/lib/auth/login_page.dart[m
[1mindex 324c77d..f125e63 100644[m
[1m--- a/capstone/lib/auth/login_page.dart[m
[1m+++ b/capstone/lib/auth/login_page.dart[m
[36m@@ -1,5 +1,6 @@[m
 import 'package:flutter/material.dart';[m
 import 'auth_service.dart';[m
[32m+[m[32mimport 'signup_page.dart';[m
 [m
 class LoginPage extends StatefulWidget {[m
   const LoginPage({super.key});[m
[36m@@ -19,7 +20,6 @@[m [mclass _LoginPageState extends State<LoginPage>[m
   late Animation<Offset> _animation;[m
   bool _obscurePassword = true;[m
   bool _isLoading = false;[m
[31m-  String? _usernameError;[m
   String? _passwordError;[m
 [m
   @override[m
[36m@@ -51,8 +51,6 @@[m [mclass _LoginPageState extends State<LoginPage>[m
 [m
     setState(() {[m
       _isLoading = true;[m
[31m-      _usernameError = null;[m
[31m-      _passwordError = null;[m
     });[m
 [m
     try {[m
[36m@@ -78,13 +76,7 @@[m [mclass _LoginPageState extends State<LoginPage>[m
   }[m
 [m
   void _handleAuthError(AuthException e) {[m
[31m-    if (e.message.toLowerCase().contains('username')) {[m
[31m-      setState(() => _usernameError = e.message);[m
[31m-    } else if (e.message.toLowerCase().contains('password')) {[m
       setState(() => _passwordError = e.message);[m
[31m-    } else {[m
[31m-      _showErrorDialog(e.message);[m
[31m-    }[m
   }[m
 [m
   void _showErrorDialog(String message) {[m
[36m@@ -119,13 +111,13 @@[m [mclass _LoginPageState extends State<LoginPage>[m
             child: Align([m
               alignment: Alignment.bottomCenter,[m
               child: Container([m
[31m-                height: MediaQuery.of(context).size.height * 0.75,[m
[32m+[m[32m                height: MediaQuery.of(context).size.height * 0.85,[m
                 decoration: const BoxDecoration([m
                   color: Colors.white,[m
[31m-                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),[m
[32m+[m[32m                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),[m
                 ),[m
                 child: SafeArea([m
[31m-                  top: false, // ignore top since it’s already aligned bottom[m
[32m+[m[32m                  top: false,[m[41m [m
                   child: LayoutBuilder([m
                     builder: (context, constraints) {[m
                       return Container([m
[36m@@ -162,7 +154,7 @@[m [mclass _LoginPageState extends State<LoginPage>[m
                                       ),[m
                                       const SizedBox(height: 40),[m
                                       _buildUsernameField(),[m
[31m-                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      const SizedBox(height: 30),[m
                                       _buildPasswordField(),[m
                                     ],[m
                                   ),[m
[36m@@ -195,9 +187,10 @@[m [mclass _LoginPageState extends State<LoginPage>[m
       controller: _usernameController,[m
       decoration: InputDecoration([m
         labelText: 'Username',[m
[31m-        prefixIcon: const Icon(Icons.person),[m
[31m-        errorText: _usernameError,[m
[31m-        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),[m
[32m+[m[32m        labelStyle: const TextStyle(),[m
[32m+[m[32m        prefixIcon: const Icon(Icons.person_outline),[m
[32m+[m[32m        errorText: null,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
       ),[m
       validator: (value) {[m
         if (value == null || value.isEmpty) {[m
[36m@@ -214,15 +207,17 @@[m [mclass _LoginPageState extends State<LoginPage>[m
       obscureText: _obscurePassword,[m
       decoration: InputDecoration([m
         labelText: 'Password',[m
[31m-        prefixIcon: const Icon(Icons.lock),[m
[32m+[m[32m        prefixIcon: const Icon(Icons.lock_outline),[m
         suffixIcon: IconButton([m
           icon: Icon([m
[31m-            _obscurePassword ? Icons.visibility : Icons.visibility_off,[m
[32m+[m[32m            _obscurePassword[m
[32m+[m[32m                ? Icons.visibility_outlined[m
[32m+[m[32m                : Icons.visibility_off_outlined,[m
           ),[m
           onPressed: _togglePasswordVisibility,[m
         ),[m
         errorText: _passwordError,[m
[31m-        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
       ),[m
       validator: (value) {[m
         if (value == null || value.isEmpty) {[m
[36m@@ -238,8 +233,8 @@[m [mclass _LoginPageState extends State<LoginPage>[m
 [m
   Widget _buildLoginButton() {[m
     return SizedBox([m
[31m-      width: 400,[m
[31m-      height: 60,[m
[32m+[m[32m      width: 248,[m
[32m+[m[32m      height: 48,[m
       child: ElevatedButton([m
         style: ElevatedButton.styleFrom([m
           backgroundColor: const Color(0xFF6055D8),[m
[36m@@ -254,9 +249,9 @@[m [mclass _LoginPageState extends State<LoginPage>[m
                   valueColor: AlwaysStoppedAnimation(Colors.white),[m
                 )[m
                 : const Text([m
[31m-                  'Login',[m
[32m+[m[32m                  'Log In',[m
                   style: TextStyle([m
[31m-                    fontSize: 25,[m
[32m+[m[32m                    fontSize: 20,[m
                     fontFamily: 'Poppins',[m
                     fontWeight: FontWeight.w800,[m
                     letterSpacing: 0.5,[m
[36m@@ -271,10 +266,13 @@[m [mclass _LoginPageState extends State<LoginPage>[m
     return Row([m
       mainAxisAlignment: MainAxisAlignment.center,[m
       children: [[m
[31m-        Text("Don't have account?", style: TextStyle(fontSize: 15)),[m
[32m+[m[32m        Text("Don't have an account?", style: TextStyle(fontSize: 15)),[m
         TextButton([m
           onPressed: () {[m
[31m-            // Navigate to sign up page[m
[32m+[m[32m            Navigator.push([m
[32m+[m[32m              context,[m
[32m+[m[32m              MaterialPageRoute(builder: (context) => const SignUpPage()),[m
[32m+[m[32m            );[m
           },[m
           child: const Text([m
             "Sign up",[m
[1mdiff --git a/capstone/lib/auth/signup_page.dart b/capstone/lib/auth/signup_page.dart[m
[1mindex e69de29..a21469f 100644[m
[1m--- a/capstone/lib/auth/signup_page.dart[m
[1m+++ b/capstone/lib/auth/signup_page.dart[m
[36m@@ -0,0 +1,417 @@[m
[32m+[m[32mimport 'package:flutter/material.dart';[m
[32m+[m[32mimport 'auth_service.dart';[m
[32m+[m[32mimport 'login_page.dart';[m
[32m+[m
[32m+[m[32mclass SignUpPage extends StatefulWidget {[m
[32m+[m[32m  const SignUpPage({super.key});[m
[32m+[m
[32m+[m[32m  @override[m
[32m+[m[32m  State<SignUpPage> createState() => _SignUpPageState();[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mclass _SignUpPageState extends State<SignUpPage>[m
[32m+[m[32m    with SingleTickerProviderStateMixin {[m
[32m+[m[32m  final _formKey = GlobalKey<FormState>();[m
[32m+[m[32m  final _usernameController = TextEditingController();[m
[32m+[m[32m  final _emailController = TextEditingController();[m
[32m+[m[32m  final _passwordController = TextEditingController();[m
[32m+[m[32m  final _confirmPasswordController = TextEditingController();[m
[32m+[m[32m  final _fullNameController = TextEditingController();[m
[32m+[m[32m  final _authService = AuthService();[m
[32m+[m
[32m+[m[32m  late AnimationController _animationController;[m
[32m+[m[32m  late Animation<Offset> _animation;[m
[32m+[m[32m  bool _obscurePassword = true;[m
[32m+[m[32m  bool _obscureConfirmPassword = true;[m
[32m+[m[32m  bool _isLoading = false;[m
[32m+[m[32m  String? _usernameError;[m
[32m+[m[32m  String? _emailError;[m
[32m+[m[32m  String? _passwordError;[m
[32m+[m[32m  String? _confirmPasswordError;[m
[32m+[m[32m  String? _fullNameError;[m
[32m+[m[32m  String? _generalError;[m
[32m+[m
[32m+[m[32m  @override[m
[32m+[m[32m  void initState() {[m
[32m+[m[32m    super.initState();[m
[32m+[m[32m    _animationController = AnimationController([m
[32m+[m[32m      vsync: this,[m
[32m+[m[32m      duration: const Duration(milliseconds: 600),[m
[32m+[m[32m    );[m
[32m+[m[32m    _animation = Tween<Offset>([m
[32m+[m[32m      begin: const Offset(0, 1),[m
[32m+[m[32m      end: Offset.zero,[m
[32m+[m[32m    ).animate([m
[32m+[m[32m      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),[m
[32m+[m[32m    );[m
[32m+[m[32m    _animationController.forward();[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  @override[m
[32m+[m[32m  void dispose() {[m
[32m+[m[32m    _animationController.stop();[m
[32m+[m[32m    _animationController.dispose();[m
[32m+[m[32m    _usernameController.dispose();[m
[32m+[m[32m    _emailController.dispose();[m
[32m+[m[32m    _passwordController.dispose();[m
[32m+[m[32m    _confirmPasswordController.dispose();[m
[32m+[m[32m    _fullNameController.dispose();[m
[32m+[m[32m    super.dispose();[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Future<void> _signUp() async {[m
[32m+[m
[32m+[m[32m    setState(() {[m
[32m+[m[32m      _isLoading = true;[m
[32m+[m[32m      _usernameError = null;[m
[32m+[m[32m      _emailError = null;[m
[32m+[m[32m      _passwordError = null;[m
[32m+[m[32m      _confirmPasswordError = null;[m
[32m+[m[32m      _fullNameError = null;[m
[32m+[m[32m      _generalError = null;[m
[32m+[m[32m    });[m
[32m+[m
[32m+[m[32m    if (_areFieldsEmpty()) {[m
[32m+[m[32m      setState(() {[m
[32m+[m[32m        _isLoading = false;[m
[32m+[m[32m        _generalError = 'Please fill in all fields';[m
[32m+[m[32m      });[m
[32m+[m[32m      return;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    if (!_formKey.currentState!.validate()) {[m
[32m+[m[32m      setState(() => _isLoading = false);[m
[32m+[m[32m      return;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    try {[m
[32m+[m[32m      await _authService.signUp([m
[32m+[m[32m        username: _usernameController.text.trim(),[m
[32m+[m[32m        email: _emailController.text.trim(),[m
[32m+[m[32m        password: _passwordController.text.trim(),[m
[32m+[m[32m        fullName: _fullNameController.text.trim(),[m
[32m+[m[32m      );[m
[32m+[m
[32m+[m[32m      if (!mounted) return;[m
[32m+[m[32m      Navigator.pushReplacement([m
[32m+[m[32m        context,[m
[32m+[m[32m        MaterialPageRoute(builder: (context) => const HomePage()),[m
[32m+[m[32m      );[m
[32m+[m[41m      [m
[32m+[m[32m    } on AuthException catch (e) {[m
[32m+[m[32m      _handleAuthError(e);[m
[32m+[m[32m    } catch (e) {[m
[32m+[m[32m      _showErrorDialog('An unexpected error occurred');[m
[32m+[m[32m    } finally {[m
[32m+[m[32m      if (mounted) {[m
[32m+[m[32m        setState(() => _isLoading = false);[m
[32m+[m[32m      }[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  void _handleAuthError(AuthException e) {[m
[32m+[m[32m    final message = e.message.toLowerCase();[m
[32m+[m[32m    if (message.contains('username')) {[m
[32m+[m[32m      setState(() => _usernameError = e.message);[m
[32m+[m[32m    } else if (message.contains('email')) {[m
[32m+[m[32m      setState(() => _emailError = e.message);[m
[32m+[m[32m    } else if (message.contains('password')) {[m
[32m+[m[32m      setState(() => _passwordError = e.message);[m
[32m+[m[32m    } else {[m
[32m+[m[32m      _showErrorDialog(e.message);[m
[32m+[m[32m    }[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  void _showErrorDialog(String message) {[m
[32m+[m[32m    showDialog([m
[32m+[m[32m      context: context,[m
[32m+[m[32m      builder:[m
[32m+[m[32m          (context) => AlertDialog([m
[32m+[m[32m            title: const Text('Error'),[m
[32m+[m[32m            content: Text(message),[m
[32m+[m[32m            actions: [[m
[32m+[m[32m              TextButton([m
[32m+[m[32m                onPressed: () => Navigator.pop(context),[m
[32m+[m[32m                child: const Text('OK'),[m
[32m+[m[32m              ),[m
[32m+[m[32m            ],[m
[32m+[m[32m          ),[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  bool _areFieldsEmpty() {[m
[32m+[m[32m    return _fullNameController.text.isEmpty ||[m
[32m+[m[32m        _usernameController.text.isEmpty ||[m
[32m+[m[32m        _emailController.text.isEmpty ||[m
[32m+[m[32m        _passwordController.text.isEmpty ||[m
[32m+[m[32m        _confirmPasswordController.text.isEmpty;[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  void _togglePasswordVisibility() {[m
[32m+[m[32m    setState(() => _obscurePassword = !_obscurePassword);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  void _toggleConfirmPasswordVisibility() {[m
[32m+[m[32m    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m
[32m+[m[32m@override[m
[32m+[m[32m  Widget build(BuildContext context) {[m
[32m+[m[32m    return Scaffold([m
[32m+[m[32m      backgroundColor: const Color(0xFF6055D8),[m
[32m+[m[32m      body: Stack([m
[32m+[m[32m        children: [[m
[32m+[m[32m          SlideTransition([m
[32m+[m[32m            position: _animation,[m
[32m+[m[32m            child: Align([m
[32m+[m[32m              alignment: Alignment.bottomCenter,[m
[32m+[m[32m              child: Container([m
[32m+[m[32m                height: MediaQuery.of(context).size.height * 0.85,[m
[32m+[m[32m                decoration: const BoxDecoration([m
[32m+[m[32m                  color: Colors.white,[m
[32m+[m[32m                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),[m
[32m+[m[32m                ),[m
[32m+[m[32m                child: SafeArea([m
[32m+[m[32m                  top: false,[m
[32m+[m[32m                  child: LayoutBuilder([m
[32m+[m[32m                    builder: (context, constraints) {[m
[32m+[m[32m                      return Container([m
[32m+[m[32m                        padding: const EdgeInsets.symmetric([m
[32m+[m[32m                          horizontal: 30,[m
[32m+[m[32m                          vertical: 30,[m
[32m+[m[32m                        ),[m
[32m+[m[32m                        child: ConstrainedBox([m
[32m+[m[32m                          constraints: BoxConstraints([m
[32m+[m[32m                            minHeight: constraints.maxHeight,[m
[32m+[m[32m                          ),[m
[32m+[m[32m                          child: IntrinsicHeight([m
[32m+[m[32m                            child: Form([m
[32m+[m[32m                              key: _formKey,[m
[32m+[m[32m                              child: Column([m
[32m+[m[32m                                mainAxisAlignment:[m
[32m+[m[32m                                    MainAxisAlignment.spaceBetween,[m
[32m+[m[32m                                crossAxisAlignment: CrossAxisAlignment.stretch,[m
[32m+[m[32m                                children: [[m
[32m+[m[32m                                  Column([m
[32m+[m[32m                                    crossAxisAlignment:[m
[32m+[m[32m                                        CrossAxisAlignment.start,[m
[32m+[m[32m                                    children: [[m
[32m+[m[32m                                      Center([m
[32m+[m[32m                                        child: const Text([m
[32m+[m[32m                                          'Sign Up',[m
[32m+[m[32m                                          style: TextStyle([m
[32m+[m[32m                                            fontFamily: 'Poppins',[m
[32m+[m[32m                                            fontSize: 45,[m
[32m+[m[32m                                            fontWeight: FontWeight.bold,[m
[32m+[m[32m                                            color: Color(0xFF6055D8),[m
[32m+[m[32m                                          ),[m
[32m+[m[32m                                        ),[m
[32m+[m[32m                                      ),[m
[32m+[m[32m                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      _buildFullNameField(),[m
[32m+[m[32m                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      _buildUsernameField(),[m
[32m+[m[32m                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      _buildEmailField(),[m
[32m+[m[32m                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      _buildPasswordField(),[m
[32m+[m[32m                                      const SizedBox(height: 20),[m
[32m+[m[32m                                      _buildConfirmPasswordField(),[m
[32m+[m[32m                                      if (_generalError != null) ...[[m
[32m+[m[32m                                        const SizedBox(height: 10),[m
[32m+[m[32m                                        Center([m
[32m+[m[32m                                          child: Text([m
[32m+[m[32m                                            _generalError!,[m
[32m+[m[32m                                            style: const TextStyle([m
[32m+[m[32m                                              color: Colors.red,[m
[32m+[m[32m                                              fontSize: 14,[m
[32m+[m[32m                                            ),[m
[32m+[m[32m                                            textAlign: TextAlign.center,[m
[32m+[m[32m                                          ),[m
[32m+[m[32m                                        ),[m
[32m+[m[32m                                      ],[m
[32m+[m[32m                                    ],[m
[32m+[m[32m                                  ),[m
[32m+[m[32m                                  Column([m
[32m+[m[32m                                    children: [[m
[32m+[m[32m                                      _buildSignUpButton(),[m
[32m+[m[32m                                      const SizedBox(height: 10),[m
[32m+[m[32m                                      _buildLoginText(),[m
[32m+[m[32m                                    ],[m
[32m+[m[32m                                  ),[m
[32m+[m[32m                                ],[m
[32m+[m[32m                              ),[m
[32m+[m[32m                            ),[m
[32m+[m[32m                          ),[m
[32m+[m[32m                        ),[m
[32m+[m[32m                      );[m
[32m+[m[32m                    },[m
[32m+[m[32m                  ),[m
[32m+[m[32m                ),[m
[32m+[m[32m              ),[m
[32m+[m[32m            ),[m
[32m+[m[32m          ),[m
[32m+[m[32m        ],[m
[32m+[m[32m      ),[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildFullNameField() {[m
[32m+[m[32m    return TextFormField([m
[32m+[m[32m      controller: _fullNameController,[m
[32m+[m[32m      decoration: InputDecoration([m
[32m+[m[32m        labelText: 'Full Name',[m
[32m+[m[32m        prefixIcon: const Icon(Icons.person_outline),[m
[32m+[m[32m        errorText: _fullNameError,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
[32m+[m[32m      ),[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildUsernameField() {[m
[32m+[m[32m    return TextFormField([m
[32m+[m[32m      controller: _usernameController,[m
[32m+[m[32m      decoration: InputDecoration([m
[32m+[m[32m        labelText: 'Username',[m
[32m+[m[32m        prefixIcon: const Icon(Icons.alternate_email),[m
[32m+[m[32m        errorText: _usernameError,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
[32m+[m[32m      ),[m
[32m+[m[32m      validator: (value) {[m
[32m+[m[32m        if (value!.length < 4) {[m
[32m+[m[32m          return 'Username must be at least 4 characters';[m
[32m+[m[32m        }[m
[32m+[m[32m        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {[m
[32m+[m[32m          return 'Username can only contain letters, numbers and underscores';[m
[32m+[m[32m        }[m
[32m+[m[32m        return null;[m
[32m+[m[32m      },[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildEmailField() {[m
[32m+[m[32m    return TextFormField([m
[32m+[m[32m      controller: _emailController,[m
[32m+[m[32m      keyboardType: TextInputType.emailAddress,[m
[32m+[m[32m      decoration: InputDecoration([m
[32m+[m[32m        labelText: 'Email',[m
[32m+[m[32m        prefixIcon: const Icon(Icons.email_outlined),[m
[32m+[m[32m        errorText: _emailError,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
[32m+[m[32m      ),[m
[32m+[m[32m      validator: (value) {[m
[32m+[m[32m        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {[m
[32m+[m[32m          return 'Please enter a valid email';[m
[32m+[m[32m        }[m
[32m+[m[32m        return null;[m
[32m+[m[32m      },[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildPasswordField() {[m
[32m+[m[32m    return TextFormField([m
[32m+[m[32m      controller: _passwordController,[m
[32m+[m[32m      obscureText: _obscurePassword,[m
[32m+[m[32m      decoration: InputDecoration([m
[32m+[m[32m        labelText: 'Password',[m
[32m+[m[32m        prefixIcon: const Icon(Icons.lock_outline),[m
[32m+[m[32m        suffixIcon: IconButton([m
[32m+[m[32m          icon: Icon([m
[32m+[m[32m            _obscurePassword[m
[32m+[m[32m                ? Icons.visibility_outlined[m
[32m+[m[32m                : Icons.visibility_off_outlined,[m
[32m+[m[32m          ),[m
[32m+[m[32m          onPressed: _togglePasswordVisibility,[m
[32m+[m[32m        ),[m
[32m+[m[32m        errorText: _passwordError,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
[32m+[m[32m      ),[m
[32m+[m[32m      validator: (value) {[m
[32m+[m[32m        if (value!.length < 6) {[m
[32m+[m[32m          return 'Password must be at least 6 characters';[m
[32m+[m[32m        }[m
[32m+[m[32m        return null;[m
[32m+[m[32m      },[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildConfirmPasswordField() {[m
[32m+[m[32m    return TextFormField([m
[32m+[m[32m      controller: _confirmPasswordController,[m
[32m+[m[32m      obscureText: _obscureConfirmPassword,[m
[32m+[m[32m      decoration: InputDecoration([m
[32m+[m[32m        labelText: 'Confirm Password',[m
[32m+[m[32m        prefixIcon: const Icon(Icons.lock_outline,),[m
[32m+[m[32m        suffixIcon: IconButton([m
[32m+[m[32m          icon: Icon([m
[32m+[m[32m            _obscureConfirmPassword[m
[32m+[m[32m                ? Icons.visibility_outlined[m
[32m+[m[32m                : Icons.visibility_off_outlined,[m
[32m+[m[32m          ),[m
[32m+[m[32m          onPressed: _toggleConfirmPasswordVisibility,[m
[32m+[m[32m        ),[m
[32m+[m[32m        errorText: _confirmPasswordError,[m
[32m+[m[32m        border: UnderlineInputBorder(),[m
[32m+[m[32m      ),[m
[32m+[m[32m      validator: (value) {[m
[32m+[m[32m        if (value != _passwordController.text) {[m
[32m+[m[32m          return 'Passwords do not match';[m
[32m+[m[32m        }[m
[32m+[m[32m        return null;[m
[32m+[m[32m      },[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildSignUpButton() {[m
[32m+[m[32m    return SizedBox([m
[32m+[m[32m      width: 248,[m
[32m+[m[32m      height: 48,[m
[32m+[m[32m      child: ElevatedButton([m
[32m+[m[32m        style: ElevatedButton.styleFrom([m
[32m+[m[32m          backgroundColor: const Color(0xFF6055D8),[m
[32m+[m[32m          shape: RoundedRectangleBorder([m
[32m+[m[32m            borderRadius: BorderRadius.circular(12),[m
[32m+[m[32m          ),[m
[32m+[m[32m        ),[m
[32m+[m[32m        onPressed: _isLoading ? null : _signUp,[m
[32m+[m[32m        child:[m
[32m+[m[32m            _isLoading[m
[32m+[m[32m                ? const CircularProgressIndicator([m
[32m+[m[32m                  valueColor: AlwaysStoppedAnimation(Colors.white),[m
[32m+[m[32m                )[m
[32m+[m[32m                : const Text([m
[32m+[m[32m                  'Sign Up',[m
[32m+[m[32m                  style: TextStyle([m
[32m+[m[32m                    fontSize: 20,[m
[32m+[m[32m                    fontFamily: 'Poppins',[m
[32m+[m[32m                    fontWeight: FontWeight.w800,[m
[32m+[m[32m                    letterSpacing: 0.5,[m
[32m+[m[32m                    color: Colors.white,[m
[32m+[m[32m                  ),[m
[32m+[m[32m                ),[m
[32m+[m[32m      ),[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  Widget _buildLoginText() {[m
[32m+[m[32m    return Row([m
[32m+[m[32m      mainAxisAlignment: MainAxisAlignment.center,[m
[32m+[m[32m      children: [[m
[32m+[m[32m        const Text("Already have an account?", style: TextStyle(fontSize: 15)),[m
[32m+[m[32m        TextButton([m
[32m+[m[32m          onPressed: () {[m
[32m+[m[32m            Navigator.pushReplacement([m
[32m+[m[32m              context,[m
[32m+[m[32m              MaterialPageRoute(builder: (context) => const LoginPage()),[m
[32m+[m[32m            );[m
[32m+[m[32m          },[m
[32m+[m[32m          child: const Text([m
[32m+[m[32m            "Log In",[m
[32m+[m[32m            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),[m
[32m+[m[32m          ),[m
[32m+[m[32m        ),[m
[32m+[m[32m      ],[m
[32m+[m[32m    );[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[1mdiff --git a/capstone/lib/main.dart b/capstone/lib/main.dart[m
[1mindex 04c015f..6bd9e46 100644[m
[1m--- a/capstone/lib/main.dart[m
[1m+++ b/capstone/lib/main.dart[m
[36m@@ -18,7 +18,7 @@[m [mclass MyApp extends StatelessWidget {[m
   Widget build(BuildContext context) {[m
     return MaterialApp([m
       debugShowCheckedModeBanner: false,[m
[31m-      title: 'Demo',[m
[32m+[m[32m      title: 'Test',[m
       theme: ThemeData([m
         [m
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),[m
