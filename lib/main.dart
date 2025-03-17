import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // Initialize here

  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings); // Ensure this completes before proceeding

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF1A3C40), // Dark teal background for the app
        primaryColor: Color(0xFF1A3C40), // Match primary color to background
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF26A69A)), // Lighter teal for accents
        appBarTheme: AppBarTheme(
          color: Color(0xFF1A3C40), // Dark teal for AppBar
          iconTheme: IconThemeData(color: Colors.white), // White icons
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Color(0xFF1A3C40), // Dark teal for drawer
        ),
        textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Replaces bodyText1
        bodyMedium: TextStyle(color: Colors.white), // Replaces bodyText2
        titleLarge: TextStyle(color: Colors.white), // Replaces headline6
      ),
      ),
    );
  }
}


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the HomeScreen after 4 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A3C40), Color(0xFF2A2D34)], // Modern gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Welcome Logo
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 2),
                curve: Curves.easeOutExpo,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Image.asset(
                        'assets/welcome_logo.jpg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Animated Welcome Text
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 30, end: 0),
                duration: Duration(seconds: 2),
                curve: Curves.easeOutExpo,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: Opacity(
                      opacity: (30 - value) / 30,
                      child: Text(
                        'أهلاً بكم في تطبيق هدف 1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Detailed Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 50, end: 0),
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOutExpo,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, value),
                      child: Opacity(
                        opacity: (50 - value) / 50,
                        child: Text(
                          '''📍 اسم المدرسة: مدرسة وادي الحلو الحلقة الاولى والثانية والثالثة -بنين  
💡 اسم المبادرة: نحن عونك فاطمئن  
🌟 اسم الفريق: فريق الهلال الطلابي لجائزة عون''',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              // Loading Indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MuscleBuildingScreen extends StatefulWidget {
  const MuscleBuildingScreen({Key? key}) : super(key: key);

  @override
  _MuscleBuildingScreenState createState() => _MuscleBuildingScreenState();
}

class _MuscleBuildingScreenState extends State<MuscleBuildingScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  String _selectedSex = "ذكر";
  String _selectedWorkoutFrequency = "يوميا";
  String _selectedGoal = "زيادة الكتلة العضلية";

  final List<String> _sexOptions = ["ذكر", "أنثى"];
  final List<String> _workoutOptions = [
    "يوميا",
    "مرتين في الأسبوع",
    "ثلاث مرات في الأسبوع",
    "أربع مرات في الأسبوع",
    "لا أتمرن"
  ];
  final List<String> _goalOptions = [
    "زيادة الكتلة العضلية",
    "خسارة الوزن",
    "كلاهما"
  ];


  void _submitData() {
    String weight = _weightController.text;
    String height = _heightController.text;
    String age = _ageController.text;

    if (weight.isEmpty || height.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى ملء جميع الحقول")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          weight: double.parse(weight),
          height: double.parse(height),
          age: int.parse(age),
          sex: _selectedSex,
          workoutFrequency: _selectedWorkoutFrequency,
          goal: _selectedGoal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text("بناء العضلات")),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("الوزن (كجم)", _weightController),
                _buildTextField("الطول (سم)", _heightController),
                _buildTextField("العمر", _ageController),
                SizedBox(height: 20),
                _buildDropdown("الجنس", _selectedSex, _sexOptions, (newValue) {
                  setState(() {
                    _selectedSex = newValue!;
                  });
                }),
                SizedBox(height: 20),
                _buildDropdown("كم مرة تتمرن؟", _selectedWorkoutFrequency, _workoutOptions, (newValue) {
                  setState(() {
                    _selectedWorkoutFrequency = newValue!;
                  });
                }),
                SizedBox(height: 20),
                _buildDropdown("اختر هدفك", _selectedGoal, _goalOptions, (newValue) {
                  setState(() {
                    _selectedGoal = newValue!;
                  });
                }),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF26A69A),
                    ),
                    child: Text("تحليل النتئج", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.white), // Set input text color to white
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 52, 52, 59),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}


  Widget _buildDropdown(String label, String selectedValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Color.fromARGB(255, 52, 52, 59),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            onChanged: (value) {
              onChanged(value);
            },
            style: TextStyle(color: Colors.white, fontSize: 16),
            dropdownColor: Color.fromRGBO(52, 52, 59, 0.8),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(option, style: TextStyle(color: Colors.white)),
                ),
              );
            }).toList(),
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final double weight;
  final double height;
  final int age;
  final String sex;
  final String workoutFrequency;
  final String goal;

  const LoadingScreen({Key? key, required this.weight, required this.height, required this.age, required this.sex, required this.workoutFrequency, required this.goal}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultsScreen(
              weight: widget.weight,
              height: widget.height,
              age: widget.age,
              sex: widget.sex,
              workoutFrequency: widget.workoutFrequency,
              goal: widget.goal,
            )),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("جاري تحليل البيانات...", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class ResultsScreen extends StatefulWidget {
  final double weight;
  final double height;
  final int age;
  final String sex;
  final String workoutFrequency;
  final String goal;

  const ResultsScreen({Key? key,
    required this.weight,
    required this.height,
    required this.age,
    required this.sex,
    required this.workoutFrequency,
    required this.goal,
  }) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  
  Future<List<String>> fetchHealthAdvice() async {
  const String apiKey = "";
  const String apiUrl = "https://api.openai.com/v1/chat/completions";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "أنت مساعد صحي. قدم نصائح صحية بناءً على مدخلات المستخدم. "
                "استجب بتنسيق JSON فقط دون أي نص خارجي. "
                "أعد كائن JSON يحتوي على 5 نصائح صحية ضمن المفتاح 'tips', "
                "بحيث تحتوي كل نصيحة على 'title' و 'description'."
          },
          {
            "role": "user",
            "content": "الوزن: ${widget.weight} كجم، الطول: ${widget.height} سم، العمر: ${widget.age} سنة، "
                "الجنس: ${widget.sex}، تكرار التمارين: ${widget.workoutFrequency}، الهدف: ${widget.goal}."
          }
        ],
        "max_tokens": 500,
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (data.containsKey("choices") && data["choices"].isNotEmpty) {
        String aiResponse = data["choices"][0]["message"]["content"];

        // Log AI response for debugging
        print("🔍 Raw AI Response: $aiResponse");

        // Clean JSON formatting
        aiResponse = aiResponse.replaceAll(RegExp(r'```json|```'), '').trim();

        // Ensure UTF-8 decoding
        aiResponse = utf8.decode(aiResponse.runes.toList());

        final jsonData = jsonDecode(aiResponse);
        if (jsonData.containsKey("tips") && jsonData["tips"] is List) {
          return jsonData["tips"]
              .map<String>((tip) => "${tip["title"]}: ${tip["description"]}")
              .toList();
        } else {
          print("⚠️ Unexpected AI Response: $jsonData");
        }
      } else {
        print("⚠️ No choices in response: $data");
      }
    } else {
      print("❌ API Error: ${response.statusCode} - ${response.body}");
    }
      throw Exception("Failed to fetch health tips.");
    } catch (e) {
        print("❌ Error fetching health tips: $e");
        return ["❌ تعذر تحميل النصائح الصحية، حاول مرة أخرى لاحقًا."];
      }
  } 


  @override
    void initState() {
      super.initState();
      _fetchAndScheduleHealthTips();
    }

  void _fetchAndScheduleHealthTips() async {
  List<String> healthTips = await fetchHealthAdvice();
  if (healthTips.isNotEmpty) {
      _scheduleNotifications(healthTips);
      _showImmediateNotification(healthTips.first);
    }
  }

  Future<void> _showImmediateNotification(String tip) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'نصيحة صحية',
      tip,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'health_tips_channel',
          'Health Tips',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _scheduleNotifications(List<String> healthTips) async {
    for (int i = 0; i < healthTips.length; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        'نصيحة صحية',
        healthTips[i],
        tz.TZDateTime.now(tz.local).add(Duration(hours: i + 1)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'health_tips_channel',
            'Health Tips',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void _startHealthTips() async {
    List<String> healthTips = await fetchHealthAdvice();
    _scheduleNotifications(healthTips);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("سيتم إرسال نصائح صحية كل ساعة")),
    );
  }

  Widget _buildProgressCard(String label, double value, double maxValue) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.blueGrey[900],
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
        children: [
          Align(
            alignment: Alignment.center, // Ensures text is centered
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center, // Ensures the progress bar is centered
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 8.0,
              percent: (value / maxValue).clamp(0.0, 1.0),
              center: Text("${value.toStringAsFixed(1)} جرام",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              progressColor: Colors.teal,
              backgroundColor: Colors.grey[800]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    double proteinIntake = widget.weight * 2.0;
    double carbIntake = widget.weight * 3.5;
    double fatIntake = widget.weight * 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text('نتائج التحليل'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProgressCard("كمية احتياجك للبروتين", proteinIntake, 200),
              _buildProgressCard("كمية احتياجك للكربوهيدرات", carbIntake, 350),
              _buildProgressCard("كمية احتياجك للدهون", fatIntake, 100),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(' هدف 1'),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFF1A3C40), // Background color for the drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1A3C40),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'القائمة', 
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              ListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الرئيسية',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              ListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تغيير اللغة (قريبًا!)',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                onTap: () {
                  print("More Info clicked");
                },
              ),
              ListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'حول التطبيق',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'اختر هدفك الصحي',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              stylishButton(
                context,
                'نصائح تقوية الجسم',
                'assets/strength_image.jpg',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthAdviceScreen(scaffoldMessengerKey: scaffoldMessengerKey),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              stylishButton(
                context,
                'بناء العضلات',
                'assets/muscle_image.jpg',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MuscleBuildingScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              stylishButton(
                context,
                'حاسبة الوزن',
                'assets/weight_image.jpg',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BMICalculatorScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    
  }

  Widget stylishButton(BuildContext context, String text, String imagePath, VoidCallback onTap) {
  return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      );
    }


  Widget buttonWithBackgroundImage(
      BuildContext context, String title, String imagePath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


class HealthAdviceScreen extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  const HealthAdviceScreen({Key? key, required this.scaffoldMessengerKey})
      : super(key: key);

  @override
  _HealthAdviceScreenState createState() => _HealthAdviceScreenState();
}


class _HealthAdviceScreenState extends State<HealthAdviceScreen> {
  List<Map<String, String>> healthTips = [];

Future<void> fetchHealthAdvice() async {
  const String apiKey = ""; // Replace with actual key
  const String apiUrl = "https://api.openai.com/v1/chat/completions";

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "أنت مساعد ذكاء اصطناعي يقدم نصائح صحية. استجابتك يجب أن تكون بصيغة JSON فقط، بدون أي نص إضافي أو شرح."
                        "أعد كائن JSON يحتوي على 5 نصائح صحية تحت مفتاح 'tips'."
                        "يجب أن تكون النصائح مقسمة إلى: "
                        "- 1 من 'تغذية' "
                        "- 1 من 'صحة نفسية' "
                        "- 2 من 'لياقة بدنية' "
                        "- 1 من أي فئة أخرى. "
                        "كل نصيحة يجب أن تحتوي على: 'title' (العنوان), 'description' (الوصف), و 'category' (الفئة)."
                        "يجب أن تكون الفئات باللغة العربية فقط بدون رموز إضافية."
          },
          {"role": "user", "content": "أعطني 5 نصائح صحية بصيغة JSON فقط، بدون أي نص خارجي أو تنسيق غير ضروري."}
        ],
        "max_tokens": 700,
        "temperature": 0.7,
      }),
    );

    // ✅ Decode response safely
    String responseText = utf8.decode(response.bodyBytes);
    print("✅ Raw OpenAI Response: $responseText");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(responseText);

      if (data.containsKey("choices") && data["choices"].isNotEmpty) {
        String aiResponse = data["choices"][0]["message"]["content"];

        // ✅ Clean response
        aiResponse = aiResponse
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        print("✅ Cleaned OpenAI Response: $aiResponse");

        try {
          Map<String, dynamic> jsonData = jsonDecode(aiResponse);

          if (jsonData.containsKey("tips") && jsonData["tips"] is List) {
            List<dynamic> tipsList = jsonData["tips"];

            if (tipsList.length < 5) {
              throw Exception("Invalid API response: Less than 5 tips received.");
            }

            // ✅ Categorize tips
            Map<String, List<Map<String, String>>> categorizedTips = {
              'لياقة بدنية': [],
              'تغذية': [],
              'صحة نفسية': [],
              'أخرى': [],
            };

            for (var tip in tipsList) {
              if (tip is Map<String, dynamic> &&
                  tip.containsKey("title") &&
                  tip.containsKey("description") &&
                  tip.containsKey("category")) {
                String category = tip["category"].trim();
                if (categorizedTips.containsKey(category)) {
                  categorizedTips[category]!.add({
                    "title": tip["title"],
                    "description": tip["description"],
                    "image": getImageForCategory(category),
                  });
                } else {
                  categorizedTips['أخرى']!.add({
                    "title": tip["title"],
                    "description": tip["description"],
                    "image": getImageForCategory(category),
                  });
                }
              }
            }

            // ✅ Ensure we have enough tips, fill missing categories
            while (categorizedTips['لياقة بدنية']!.length < 2 && categorizedTips['أخرى']!.isNotEmpty) {
              categorizedTips['لياقة بدنية']!.add(categorizedTips['أخرى']!.removeLast());
            }
            while (categorizedTips['تغذية']!.isEmpty && categorizedTips['أخرى']!.isNotEmpty) {
              categorizedTips['تغذية']!.add(categorizedTips['أخرى']!.removeLast());
            }
            while (categorizedTips['صحة نفسية']!.isEmpty && categorizedTips['أخرى']!.isNotEmpty) {
              categorizedTips['صحة نفسية']!.add(categorizedTips['أخرى']!.removeLast());
            }

            // ✅ Pick final tips (ensuring 5 total)
            List<Map<String, String>> finalTips = [];
            finalTips.addAll(categorizedTips['لياقة بدنية']!.take(2));
            finalTips.addAll(categorizedTips['تغذية']!.take(1));
            finalTips.addAll(categorizedTips['صحة نفسية']!.take(1));
            if (finalTips.length < 5 && categorizedTips['أخرى']!.isNotEmpty) {
              finalTips.add(categorizedTips['أخرى']!.first);
            }

            if (finalTips.length < 5) {
              throw Exception("Still not enough valid tips.");
            }

            setState(() {
              healthTips = finalTips;
            });
          } else {
            throw Exception("Invalid API response: Missing or incorrect 'tips' format.");
          }
        } catch (jsonError) {
          print("❌ JSON Parse Error: $jsonError");
          throw Exception("Invalid JSON: Response may be malformed.");
        }
      } else {
        throw Exception("Invalid API response format.");
      }
    } else {
      throw Exception("API error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("❌ Error fetching health tips: $e");

    setState(() {
      healthTips = [
        {
          "title": "خطأ",
          "description": "فشل تحميل النصائح الصحية. اضغط لإعادة المحاولة.",
          "image": "assets/error.png"
        }
      ];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('خطأ: فشل تحميل النصائح الصحية')),
    );
  }
}



String getImageForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'لياقة بدنية':
      return 'assets/fitness.png';
    case 'تغذية':
      return 'assets/nutrition.png';
    case 'صحة نفسية':
      return 'assets/mental_health.png';
    default:
      return 'assets/general_health.png';
  }
}

  @override
  void initState() {
    super.initState();
    fetchHealthAdvice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Align(
        alignment: Alignment.centerRight,
        child: Text('النصائح الصحية'),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false, // Removes the default back button
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: healthTips.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: healthTips.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (healthTips[index]['title'] == "Error") fetchHealthAdvice();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                healthTips[index]['image']!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              healthTips[index]['title']!,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              healthTips[index]['description']!,
                              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Controllers
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Drop-down menu selection
  String _selectedGender = "ذكر"; // Default to Male
  final List<String> _genderOptions = ["ذكر", "أنثى"];

  // Results
  String? _perfectWeightResult;
  String? _perfectWeightWithAgeResult;
  String? _bmiResult;

  // Calculate Perfect Weight by Height
  void _calculatePerfectWeight() {
    double height = double.tryParse(_heightController.text) ?? 0;
    if (height > 0) {
      double perfectWeight = _selectedGender == "ذكر"
          ? (height - 100) * 0.9
          : (height - 100) * 0.85;
      setState(() {
        _perfectWeightResult =
            "الوزن المثالي لطولك هو: ${perfectWeight.toStringAsFixed(2)} كجم";
      });
    }
  }

  // Calculate Perfect Weight by Height and Age
  void _calculatePerfectWeightWithAge() {
    double height = double.tryParse(_heightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;
    if (height > 0 && age > 0) {
      double perfectWeight = _selectedGender == "ذكر"
          ? (height - 100 + (age / 10)) * 0.9
          : (height - 100 + (age / 10)) * 0.85;
      setState(() {
        _perfectWeightWithAgeResult =
            "الوزن المثالي لطولك وعمرك هو: ${perfectWeight.toStringAsFixed(2)} كجم";
      });
    }
  }

  // Calculate BMI and give advice
  void _calculateBMI() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    if (weight > 0 && height > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      String advice;
      if (bmi < 18.5) {
        advice = "وزنك ناقص. نصيحة: تناول وجبات غذائية متوازنة.";
      } else if (bmi < 24.9) {
        advice = "وزنك طبيعي. نصيحة: حافظ على نمط حياتك الصحي.";
      } else {
        advice =
            "وزنك زائد. نصيحة: قم بممارسة التمارين الرياضية بانتظام وتناول وجبات غذائية صحية.";
      }
      setState(() {
        _bmiResult =
            "مؤشر كتلة الجسم الخاص بك هو: ${bmi.toStringAsFixed(2)}.\n$advice";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    appBar: AppBar(
      title: Align(
        alignment: Alignment.centerRight,
        child: Text('حاسبة الوزن ومؤشر الكتلة'),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false, // Removes the default back button
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
    
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight, // Aligns text to the right
              child: Text(
                'حساب الوزن المثالي حسب الطول والعمر',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
            
            SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genderOptions.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(gender, textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'اختر الجنس',
                  labelStyle: TextStyle(color: Colors.white, textBaseline: TextBaseline.alphabetic),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 52, 59), // Matching background color
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                dropdownColor: Color.fromRGBO(52, 52, 59, 0.8), // Matching background color
              ),
            ),

            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl, // Ensures right alignment
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'أدخل الطول (سم)',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 52, 59),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl, // Ensures full right alignment
              child: TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'أدخل العمر (بالسنوات)',
                  alignLabelWithHint: true, // Ensures label aligns properly
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 52, 59),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _calculatePerfectWeightWithAge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26A69A), // Button background color
                  foregroundColor: Colors.white, // ✅ Ensures button text color is white
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Optional for better styling
                ),
                child: Text(
                  'احسب',
                  style: TextStyle(color: Colors.white), // ✅ Ensures text is white
                ),
              ),
            ),
            if (_perfectWeightWithAgeResult != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  alignment: Alignment.centerRight, // ✅ Forces the text container to the right
                  child: Text(
                    _perfectWeightWithAgeResult!,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.right, // ✅ Ensures text is right-aligned inside the container
                    textDirection: TextDirection.rtl, // ✅ Ensures correct Arabic text layout
                  ),
                ),
              ),

            SizedBox(height: 30),

            // Section 3: BMI Calculator
            Directionality(
              textDirection: TextDirection.rtl,
              child: Align(
                alignment: Alignment.centerRight, // Aligns text to the right
                  child: Text(
                    'حساب كتلة الجسم',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            ),
            SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl, // Ensures full right alignment
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'أدخل الوزن (كجم)',
                  alignLabelWithHint: true, // Ensures label aligns properly
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 52, 59),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl, // Ensures full right alignment
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'أدخل الطول (سم)',
                  alignLabelWithHint: true, // Ensures label aligns properly
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 52, 59),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26A69A), // Button background color
                  foregroundColor: Colors.white, // ✅ Ensures button text color is white
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Optional for better styling
                ),
                child: Text(
                  'احسب',
                  style: TextStyle(color: Colors.white), // ✅ Ensures text is white
                ),
              ),
            ),
            if (_bmiResult != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  alignment: Alignment.centerRight, // ✅ Forces the text container to the right
                  child: Text(
                    _bmiResult!,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.right, // ✅ Ensures text is aligned inside the container
                    textDirection: TextDirection.rtl, // ✅ Ensures Arabic text direction
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'عن التطبيق', // Arabic title
            textAlign: TextAlign.right,
          ),
        ),
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward), // Back button (Arabic-style)
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A3C40), Color(0xFF2A2D34)], // Modern gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center( // Keeps body content centered
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Body remains centered
            children: [
              // Animated Logo
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 2),
                curve: Curves.easeOutExpo,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Image.asset(
                        'assets/welcome_logo.jpg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Animated Title
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 30, end: 0),
                duration: Duration(seconds: 2),
                curve: Curves.easeOutExpo,
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: Opacity(
                      opacity: (30 - value) / 30,
                      child: Text(
                        'أهلاً بكم في تطبيق هدف 1',
                        textAlign: TextAlign.right, // Title text aligned to the right
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 50, end: 0),
                  duration: Duration(seconds: 2),
                  curve: Curves.easeOutExpo,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, value),
                      child: Opacity(
                        opacity: (50 - value) / 50,
                        child: Text(
                          '''📍 اسم المدرسة: مدرسة وادي الحلو الحلقة الاولى والثانية والثالثة -بنين  
💡 اسم المبادرة: نحن عونك فاطمئن  
🌟 اسم الفريق: فريق الهلال الطلابي لجائزة عون''',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
