import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncspace/resource/jitsi_meet_methods.dart';
import '../widgets/home_meeting_button.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({super.key});
  
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  Future<void> createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 1000000).toString();
    await _jitsiMeetMethods.createMeeting(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  void joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Ensure a Scaffold for better layout
      appBar: AppBar(
        title: Text('Meetings'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeMeetingButton(
                onPressed: createNewMeeting,
                text: 'New Meeting',
                icon: Icons.videocam,
              ),
              HomeMeetingButton(
                onPressed: () => joinMeeting(context),
                text: 'Join Meeting',
                icon: Icons.add_box_rounded,
              ),
              HomeMeetingButton(
                onPressed: () {},
                text: 'Schedule',
                icon: Icons.calendar_today,
              ),
              HomeMeetingButton(
                onPressed: () {},
                text: 'Share Screen',
                icon: Icons.arrow_upward_rounded,
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Create/Join Meetings with just a click',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
