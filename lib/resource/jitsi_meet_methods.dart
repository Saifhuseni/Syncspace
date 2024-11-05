// import 'package:jitsi_meet/feature_flag/feature_flag.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:syncspace/resource/auth_method.dart';
// import 'package:syncspace/resource/firestore_methods.dart';
//
// class JitsiMeetMethods {
//   final AuthMethods _authMethods = AuthMethods();
//   final FirestoreMethods _firestoreMethods = FirestoreMethods();
//   void createMeeting({
//     required String roomName,
//     required bool isAudioMuted,
//     required bool isVideoMuted,
//     String username = '',
//   })async{
//     try {
//       FeatureFlag featureFlag = FeatureFlag();
//       featureFlag.welcomePageEnabled = false;
//       featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION; // Limit video resolution to 360p
//       String name;
//       if(username.isEmpty){
//         name = _authMethods.user.displayName!;
//       }
//       else{
//         name = username;
//       }
//       var options = JitsiMeetingOptions(
//         room: roomName
//       )
//         // ..serverURL = "https://someHost.com"
//         // ..subject = "Meeting with Gunschu"
//         ..userDisplayName = name
//         ..userEmail = _authMethods.user.email
//         ..userAvatarURL = _authMethods.user.photoURL // or .png
//         // ..audioOnly = true
//         ..audioMuted = isAudioMuted
//         ..videoMuted = isVideoMuted;
//
//       _firestoreMethods.addMeetingHistory(roomName);
//       await JitsiMeet.joinMeeting(options);
//     } catch (error) {
//       print("error: $error");
//     }
//   }
// }

//---------------------------------------------------------------------------------------------------

import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:syncspace/resource/auth_method.dart';
import 'package:syncspace/resource/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  Future<void> createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }

      // Setting up the meeting options
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        userDisplayName: name,
        userEmail: _authMethods.user.email,
        userAvatarUrl: _authMethods.user.photoURL,
        isAudioMuted: isAudioMuted, // Corrected parameter name
        isVideoMuted: isVideoMuted,
      );

      // Joining the meeting using the Jitsi Meet Wrapper
      await JitsiMeetWrapper.joinMeeting(
        options: options,
      );

      // Storing meeting history in Firestore
      _firestoreMethods.addMeetingHistory(roomName);
    } catch (error) {
      print("error: $error");
    }
  }
}



// -------------------------------------------------------------------------------------------------

// // import 'package:jitsi_meet/feature_flag/feature_flag.dart';
// // import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
// import 'package:syncspace/resource/auth_method.dart';
// import 'package:syncspace/resource/firestore_methods.dart';
//
// class JitsiMeetMethods {
//   final AuthMethods _authMethods = AuthMethods();
//   final FirestoreMethods _firestoreMethods = FirestoreMethods();
//
//   void createMeeting({
//     required String roomName,
//     required bool isAudioMuted,
//     required bool isVideoMuted,
//     String username = '',
//   }) async {
//     try {
//       // Configure feature flags
//       FeatureFlag featureFlag = FeatureFlag();
//       featureFlag.welcomePageEnabled = false;
//       featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;
//
//       // Get user information
//       String name = username.isNotEmpty
//           ? username
//           : (_authMethods.user?.displayName ?? 'Guest');
//       String email = _authMethods.user?.email ?? '';
//       String avatarURL = _authMethods.user?.photoURL ?? '';
//
//       // Meeting options
//       var options = JitsiMeetingOptions(room: roomName)
//         ..userDisplayName = name
//         ..userEmail = email
//         ..userAvatarURL = avatarURL
//         ..audioMuted = isAudioMuted
//         ..videoMuted = isVideoMuted;
//
//       // Add meeting to Firestore history
//       _firestoreMethods.addMeetingHistory(roomName);
//
//       // Join meeting
//       await JitsiMeet.joinMeeting(options);
//     } catch (error) {
//       print("Error: $error");
//     }
//   }
// }

// -----------------------------------------------------------------------------------------------

// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
// import 'package:syncspace/resource/auth_method.dart';
// import 'package:syncspace/resource/firestore_methods.dart';
//
// class JitsiMeetMethods {
//   final AuthMethods _authMethods = AuthMethods();
//   final FirestoreMethods _firestoreMethods = FirestoreMethods();
//
//   Future<void> createMeeting({
//     required String roomName,
//     required bool isAudioMuted,
//     required bool isVideoMuted,
//     String username = '',
//   }) async {
//     try {
//       String name;
//       if (username.isEmpty) {
//         name = _authMethods.user?.displayName ?? 'Guest';
//       } else {
//         name = username;
//       }
//
//       // Constructing the meeting options using the wrapper SDK's method
//       var options = JitsiMeetingOptions(
//         roomNameOrUrl: roomName,
//         userDisplayName: name,
//         userEmail: _authMethods.user?.email,
//         userAvatarUrl: _authMethods.user?.photoURL,
//         isAudioMuted: isAudioMuted,
//         isVideoMuted: isVideoMuted,
//       );
//
//       // Adding meeting to Firestore
//       _firestoreMethods.addMeetingHistory(roomName);
//
//       // Joining the meeting using the wrapper SDK
//       await JitsiMeetWrapper.joinMeeting(
//         options: options,
//         listener: JitsiMeetingListener(
//           onConferenceWillJoin: (message) {
//             print("Conference will join: $message");
//           },
//           onConferenceJoined: (message) {
//             print("Conference joined: $message");
//           },
//           onConferenceTerminated: (message, error) {
//             print("Conference terminated: $message, error: $error");
//           },
//         ),
//       );
//     } catch (error) {
//       print("Error: $error");
//     }
//   }
// }

