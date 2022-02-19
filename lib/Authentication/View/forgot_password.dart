import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Utils/color_constants.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: greyColor,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          SvgPicture.asset(
            'assets/images/forgot_password.svg',
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Forgot\nPassword',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Don't worry! It happens. Please enter the address associated with your account.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: greyColorDark,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                color: greyColorDark,
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 84,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      hintText: 'Email ID',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email ID';
                      }
                      return null;
                    },
                    onChanged: (typedString) {
                      // _book.title = typedString;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 120,
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                const Size(
                  200,
                  50,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
