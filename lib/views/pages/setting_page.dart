import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController controller = TextEditingController();
  bool isChecked = false;
  double sliderValue = 0;
  String? dropdownButtonVal = "opt1";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
            automaticallyImplyLeading: false, // hide back button
            leading: CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Dialog Title'),
                              content: Text('This is a simple dialog message.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Alert Dialog'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AboutDialog(
                              applicationName: 'Tutorial App',
                              applicationVersion: '1.0.0',
                              applicationIcon: Icon(Icons.info),
                              children: [
                                Text(
                                  'This app is a tutorial for Flutter development.',
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('About Dialog'),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.teal,
                  //height: 1.0,
                  //indent: 1.0,
                  thickness: 4.0,
                  radius: BorderRadius.all(Radius.circular(50.0)),
                ),
                DropdownButton(
                  value: dropdownButtonVal,
                  items: [
                    DropdownMenuItem(value: "opt1", child: Text('Option 1')),
                    DropdownMenuItem(value: "opt2", child: Text('Option 2')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      dropdownButtonVal = value.toString();
                    });
                  },
                ),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  controller: controller,
                  onEditingComplete: () {
                    setState(() {
                      // empty
                    });
                  },
                ),
                SizedBox(height: 10.0),
                Text(controller.text),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  semanticLabel: "Remember me",
                ),
                CheckboxListTile(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  title: const Text("Remember me"),
                  subtitle: const Text(
                    "Check this box to remember your login details.",
                  ),
                ),
                Switch(
                  value: isChecked,
                  onChanged: (bool? value) =>
                      setState(() => isChecked = value ?? false),
                ),
                SwitchListTile.adaptive(
                  value: isChecked,
                  onChanged: (bool? value) =>
                      setState(() => isChecked = value ?? false),
                  title: const Text("Enable Notifications"),
                  subtitle: const Text(
                    "Toggle this switch to enable or disable notifications.",
                  ),
                ),
                Slider(
                  max: 100.0,
                  divisions: 10,
                  value: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Slider value: ${sliderValue.toStringAsFixed(1)}',
                        ),
                      ),
                    );
                  },
                  onDoubleTap: () {
                    setState(() {
                      sliderValue = 50.0; // Reset slider value on double tap
                    });
                  },
                  child: Image.asset(
                    'assets/images/image01.jpg',
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Image 02 tapped!')));
                  },
                  child: Image.asset(
                    'assets/images/image02.jpg',
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Wrap(
                  spacing: 10.0,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Elevated Style'),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Elevated')),
                    FilledButton(
                      onPressed: () {},
                      child: Text('Filled Button'),
                    ),
                    TextButton(onPressed: () {}, child: Text('Text Button')),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Outlined Button'),
                    ),
                    CloseButton(),
                    BackButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
