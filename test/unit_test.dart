import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:transporter/services/auth.dart';


class MockUser extends Mock implements User{}

final MockUser _mockUser = MockUser();
class MockAuth extends Mock implements FirebaseAuth {
  
  @override 
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]
      );
  }
}

void main() {
  final MockAuth mockAuth = MockAuth();
  final Auth auth = Auth(auth: mockAuth);
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(mockAuth.createUserWithEmailAndPassword(
      email: "testaccount@test.com", 
      password: "testPassword"),
      ).thenAnswer((realInvocation) => null);

      expect(await auth.createAccount(
          email: "testaccount@test.com", 
          password: "testPassword"),
        "Successfully created User");
  });


}