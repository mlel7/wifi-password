import 'dart:io';

void main() async {
  // Running command to get the list of Wi-Fi profiles
  var command = await Process.run('netsh', ['wlan', 'show', 'profiles']);
  List<String> profiles = (command.stdout as String).split('\n')
      .where((line) => line.contains('All User Profile'))
      .map((line) => line.split(":")[1].trim())
      .toList();

  // Iterating over each profile to get Wi-Fi key
  for (var profile in profiles) {
    var results = await Process.run('netsh', ['wlan', 'show', 'profile', profile, 'key=clear']);
    List<String> keyContent = (results.stdout as String).split('\n')
        .where((line) => line.contains('Key Content'))
        .map((line) => line.split(":")[1].trim())
        .toList();
    
    try {
      print('${profile.padRight(30)} |  ${keyContent[0]}');
    } catch (e) {
      print('${profile.padRight(30)} |  ');
    }
  }

  // to pause at the end
  await stdin.first;
}
