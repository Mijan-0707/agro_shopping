import 'package:agro_shopping/app/app.dart';
import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:agro_shopping/screens/nav_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => onTapLogin(context),
          child: const Text('Login with Google'),
        ),
      ),
    );
  }

  Future<void> onTapLogin(BuildContext context) async {
    {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print([googleUser?.displayName, googleUser?.email]);
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        await GoogleSignIn().signOut();

        // check user doc exists
        final userDoc = await userRef.get();
        isSeller = userDoc.data()?['isSeller'] ?? false;

        if (!userDoc.exists) {
          await userRef.set({
            'isSeller': false,
            'email': googleUser.email,
            'name': googleUser.displayName,
            'photoUrl': googleUser.photoUrl,
            'uid': FirebaseAuth.instance.currentUser!.uid,
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationWrapper()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
