import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../components/buttons.dart';
import '../../../components/input_field.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_fonts.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/auth_utils/register_utils.dart';
import '../../../utils/google_signup.dart';
import '../../../utils/tc.dart';
import '../../../utils/validator.dart';
import '../login/login.dart';
import '../login/validation_text_row.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool obsecure = true;
  bool enabled = false;
  bool isSpecialAdded = false;
  bool isNumAdded = false;
  bool isAboveEight = false;
  String confirmPassword = '';
  final _registerFormKey = GlobalKey<FormState>();
  bool value = false;
  bool passwordVisible = false;
  String? selectedValue;
  final List<String> items = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'FCT (Abuja)',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nassarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara'
  ];

  final Map<String, dynamic> _registerData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'phone': '',
    'password': ''
  };

 processMapValues(Map<String, dynamic> registerMap,ctx,key) {
    Map<String, dynamic> processedMap = {};

    registerMap.forEach((key, value) {
      if (value is String) {
        processedMap[key] = value.trim().split(' ').join('');
      } else {
        processedMap[key] = value;
      }
    });
    print(processedMap);
 setState(() {
   
 });
      RegisterUtil.register(
                           key, ctx, _registerData);
  }

  void _checkPasswordStrength(String value) {
    dynamic password = value.trim();
    setState(() {
      if (Validators.numReg.hasMatch(password)) {
        // Password has number
        isNumAdded = true;
      } else {
        isNumAdded = false;
      }

      if (password.length > 8) {
        // Password is more than 8
        isAboveEight = true;
      } else {
        isAboveEight = false;
      }
      if (isNumAdded && isAboveEight) {
        enabled = true;
      } else {
        enabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _getSize = MediaQuery.of(context).size;
    final dataFromRoute = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _registerData['phone'] = dataFromRoute["phone"];
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(AppImages.banner),
                  Positioned(
                    left: _getSize.width * 0.1,
                    bottom: _getSize.height * 0.13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: AppFonts.bodyText.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Pallete.primaryColor,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: _getSize.height * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fill in the details below to setup your ',
                              style: AppFonts.bodyText.copyWith(
                                color: Pallete.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Abja Property',
                                style: AppFonts.body1.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Pallete.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              ' Management ',
                              style: AppFonts.bodyText.copyWith(
                                color: Pallete.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'account',
                              style: AppFonts.bodyText.copyWith(
                                color: Pallete.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: Column(
                  children: [
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          CustomInput3(
                            validator: Validators.emailValidator,
                            label: 'Email',
                            hint: 'Enter your Email',
                            onChanged: (value) {
                              _registerData['email'] = value!;
                              setState(() {});
                            },
                            onSaved: (value) {
                              _registerData['email'] = value!;
                            },
                          ),
                          SizedBox(
                            height: _getSize.height * 0.05,
                          ),
                          CustomInput3(
                            validator: Validators.nameValidator,
                            label: 'First Name',
                            hint: 'First Name',
                            onSaved: (value) {
                              _registerData['firstName'] = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: _getSize.height * 0.05,
                          ),
                          CustomInput3(
                            validator: Validators.nameValidator,
                            label: 'Last Name',
                            hint: 'Last Name',
                            onSaved: (value) {
                              _registerData['lastName'] = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: _getSize.height * 0.05,
                          ),
                          CustomInput3(
                            validator: Validators.passwordValidator,
                            obsecure: !passwordVisible,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  //call set state so that the UI is rebuilt on click
                                  setState(() {
                                    //loop through either state when clicked
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  // if password visibilty is default false set icon to visible icon or else set to hide icon
                                  passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off,
                                  color: Pallete.fade, size: 18,
                                )),
                            label: 'Password',
                            hint: 'Password',
                            onChanged: (String? value) {
                              confirmPassword = value!;
                                 _registerData['password'] = value;
                            },
                            onSaved: (value) {
                              _registerData['password'] = value!;
                            },
                          ),
                          SizedBox(
                            height: _getSize.height * 0.05,
                          ),
                          CustomInput3(
                            obsecure: !passwordVisible,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  //call set state so that the UI is rebuilt on click
                                  setState(() {
                                    //loop through either state when clicked
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  // if password visibilty is default false set icon to visible icon or else set to hide icon
                                  passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off,
                                  color: Pallete.fade, size: 18,
                                )),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Confirm password cannot be empty';
                              }
                              if (value != confirmPassword) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            onSaved: (value) {
                              //_registerData['password'] = value;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _getSize.height * 0.02),
              SizedBox(
                width: _getSize.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'By clicking "Sign Up" you agree to the ',
                          style: AppFonts.bodyText.copyWith(
                            color: Pallete.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Terms',
                            style: AppFonts.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Pallete.secondaryColor),
                          ),
                        ),
                        Text(
                          ' and',
                          style: AppFonts.bodyText.copyWith(
                            color: Pallete.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ' acknowledge the ',
                          style: AppFonts.bodyText.copyWith(
                            color: Pallete.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Privacy Policy.',
                            style: AppFonts.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Pallete.secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: _getSize.height * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16),
                    child: ButtonWithFuction(
                        text: 'Sign Up',
                        onPressed: () {
                          
                          processMapValues(_registerData,context,_registerFormKey);
                     
                         
                 
                        }),
                  ),
                  SizedBox(height: _getSize.height * 0.01),
                  const LoginNavigation(
                    text2: "Already have an account? ",
                    text: 'Login',
                    dir: AppRoutes.loginScreen,
                  )
                ],
              ),
              SizedBox(height: _getSize.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
