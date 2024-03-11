import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpCheck extends StatelessWidget {
  const ExpCheck(this.child, {Key? key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersCollection.doc('pay_status').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        // exp timestamp
        final exp = (snapshot.data?.data()?['exp'] ?? 0) as Timestamp;

        // current timestamp
        final now = DateTime.now().millisecondsSinceEpoch;
        // if exp is less than current timestamp, hide the child
        return exp.millisecondsSinceEpoch > now
            ? child
            : Scaffold(
                body: Center(
                  child: Text(
                    'E X P I R E D',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
      },
    );
  }
}
