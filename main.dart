import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AriseApp());
}

// --- COLOR MATRIX THEME ---
const Color obsidianBlack = Color(0xFF050505);
const Color deepSpaceBlue = Color(0xFF0A1118);
const Color mediumSpaceBlue = Color(0xFF111E29);
const Color systemCyan = Color(0xFF00F0FF);
const Color systemCyanGlow = Color(0xFF33F3FF);
const Color borderCyanSemi = Color(0x3300F0FF);
const Color coinsGold = Color(0xFFFFAE00);
const Color penaltyRed = Color(0xFFFF1744);
const Color penaltyRedGlow = Color(0x80FF1744);
const Color highlightWhite = Color(0xFFFFFFFF);
const Color passiveGray = Color(0xFF8E9BA6);

class AriseApp extends StatelessWidget {
  const AriseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARISE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: obsidianBlack,
        colorScheme: const ColorScheme.dark(
          primary: systemCyan,
          secondary: coinsGold,
          background: obsidianBlack,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Courier', color: highlightWhite),
        ),
      ),
      home: const MainGateLayout(),
    );
  }
}

// --- GENERAL PROTOCOLS ---
class UserProfile {
  String email;
  bool isPremiumUnlocked;
  int level;
  int xp;
  int xpNeeded;

  UserProfile({
    required this.email,
    required this.isPremiumUnlocked,
    required this.level,
    required this.xp,
    required this.xpNeeded,
  });

  bool get isPremium =>
      email.trim().toLowerCase() == "irfanlatheef7@gmail.com" || isPremiumUnlocked;
}

// --- STATE MANAGEMENT CONTROLLER ---
class MainGateLayout extends StatefulWidget {
  const MainGateLayout({Key? key}) : super(key: key);

  @override
  State<MainGateLayout> createState() => _MainGateLayoutState();
}

class _MainGateLayoutState extends State<MainGateLayout> {
  // Configured default session tracking
  final UserProfile profile = UserProfile(
    email: "irfanlatheef7@gmail.com", // Set matched bypass target address
    isPremiumUnlocked: false,
    level: 18,
    xp: 2850,
    xpNeeded: 4500,
  );

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Custom responsive navigation
    final List<Widget> screens = [
      DashboardGate(profile: profile, onNavigateToScan: () {
        setState(() => _selectedTabIndex = 1);
      }),
      AIScanScreen(profile: profile),
      HoloCoachScreen(profile: profile),
      VoiceTrainerScreen(profile: profile),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_selectedTabIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: borderCyanSemi, width: 1.5),
          ),
          color: obsidianBlack,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            HapticFeedback.mediumImpact();
            setState(() => _selectedTabIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: obsidianBlack,
          selectedItemColor: systemCyanGlow,
          unselectedItemColor: passiveGray.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Courier', fontSize: 9),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'SYSTEM',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera_outlined),
              label: 'AI SCAN',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new_rounded),
              label: '3D COACH',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over_rounded),
              label: 'VOICE',
            ),
          ],
        ),
      ),
    );
  }
}

// --- MAIN CENTRAL SYSTEM DASHBOARD ---
class DashboardGate extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onNavigateToScan;

  const DashboardGate({
    Key? key,
    required this.profile,
    required this.onNavigateToScan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cyber Status Title Bar Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HUNTER REGISTRY",
                    style: TextStyle(
                      fontSize: 10,
                      color: systemCyan,
                      letterSpacing: 2,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profile.email.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: systemCyan.withOpacity(0.15),
                  border: Border.all(color: systemCyan),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "S-RANK OVERRIDE",
                  style: TextStyle(
                    color: systemCyanGlow,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // EXP Progress indicator banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: deepSpaceBlue,
              border: Border.all(color: borderCyanSemi),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LEVEL: ${profile.level}",
                      style: const TextStyle(
                        color: systemCyanGlow,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "XP: ${profile.xp} / ${profile.xpNeeded}",
                      style: const TextStyle(
                        color: passiveGray,
                        fontFamily: 'Courier',
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: profile.xp / profile.xpNeeded,
                    backgroundColor: mediumSpaceBlue,
                    color: systemCyan,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SystemSectionHeader(title: "[ REGAINED ABILITY MODULES ]"),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _buildSystemModuleCard(
                  title: "AI physique analysis camera",
                  description: "Leverages the Monarch network to compute muscle density vectors and ascension requirements.",
                  emoji: "📷",
                  onTap: onNavigateToScan,
                ),
                const SizedBox(height: 12),
                _buildSystemModuleCard(
                  title: "3D posturing coach engine",
                  description: "Real-time skeletal wireframe tracking for structural joint alignment during training sets.",
                  emoji: "🤖",
                  onTap: onNavigateToScan, // Shared gateway callback
                ),
                const SizedBox(height: 12),
                _buildSystemModuleCard(
                  title: "ARISE gym voice assistant",
                  description: "Activate with 'Arise' vocal trigger to communicate real-time directives and rep counts.",
                  emoji: "🎙️",
                  onTap: onNavigateToScan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemModuleCard({
    required String title,
    required String description,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: deepSpaceBlue,
          border: Border.all(color: borderCyanSemi.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: highlightWhite,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: passiveGray,
                      fontSize: 10,
                      height: 1.4,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: systemCyan, size: 16),
          ],
        ),
      ),
    );
  }
}

// --- PREMIUM ACCESS PAYWALL SHIELD ---
class PremiumLockWrapper extends StatefulWidget {
  final UserProfile profile;
  final String featureName;
  final Widget child;

  const PremiumLockWrapper({
    Key? key,
    required this.profile,
    required this.featureName,
    required this.child,
  }) : super(key: key);

  @override
  State<PremiumLockWrapper> createState() => _PremiumLockWrapperState();
}

class _PremiumLockWrapperState extends State<PremiumLockWrapper> {
  bool _localOverride = false;

  @override
  Widget build(BuildContext context) {
    final hasAccess = widget.profile.isPremium || _localOverride;

    if (hasAccess) {
      return widget.child;
    } else {
      return PremiumPaywallScreen(
        featureName: widget.featureName,
        profile: widget.profile,
        onUnlocked: () {
          setState(() {
            _localOverride = true;
          });
        },
      );
    }
  }
}

class PremiumPaywallScreen extends StatefulWidget {
  final String featureName;
  final UserProfile profile;
  final VoidCallback onUnlocked;

  const PremiumPaywallScreen({
    Key? key,
    required this.featureName,
    required this.profile,
    required this.onUnlocked,
  }) : super(key: key);

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isProcessing = false;
  String? _transactionStatus;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _triggerPaymentProcess() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isProcessing = true;
      _transactionStatus = "SYNCHRONIZING WITH PAYMENT SERVER...";
    });

    Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          widget.profile.isPremiumUnlocked = true;
          _isProcessing = false;
          _transactionStatus = "TRANSACTION CLEARED. ACCESS GRANTED!";
        });
        Timer(const Duration(milliseconds: 1000), () {
          widget.onUnlocked();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Orbital rotating visual lock gate
              Center(
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: GateRingPainter(
                        angle: _rotationController.value * 2 * math.pi,
                      ),
                      child: const SizedBox(
                        width: 140,
                        height: 140,
                        child: Center(
                          child: Text(
                            "⚡",
                            style: TextStyle(
                              fontSize: 38,
                              shadows: [
                                Shadow(
                                  blurRadius: 15,
                                  color: systemCyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "SYSTEM GATE LOCK",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: penaltyRed,
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.black,
                  fontSize: 22,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: penaltyRedGlow,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "RANK-S CLEARANCE SECURITY GAUGE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: highlightWhite,
                  fontFamily: 'Courier',
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: borderCyanSemi, thickness: 1),
              const SizedBox(height: 14),
              Text(
                "To unlock the advanced [${widget.featureName.toUpperCase()}] parameter module, the system mandates Rank-S awakening keys.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: passiveGray,
                  fontFamily: 'Courier',
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Package pricing visual card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: deepSpaceBlue.withOpacity(0.6),
                  border: Border.all(color: borderCyanSemi.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      "ARISE: HIGH PLAN MEMBERSHIP",
                      style: TextStyle(
                        color: coinsGold,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "₹100",
                          style: TextStyle(
                            color: highlightWhite,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            shadows: [
                              Shadow(blurRadius: 10, color: borderCyanSemi),
                            ],
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "/ LIFETIME ACCORD",
                          style: TextStyle(
                            color: passiveGray,
                            fontFamily: 'Courier',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "INCLUDES: AI physique scanner, 3D hologram pose instructor, and fully integrated real-time ARISE gym voice assistant.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: passiveGray,
                        fontFamily: 'Courier',
                        fontSize: 9,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Purchase core trigger
              InkWell(
                onTap: _isProcessing ? null : _triggerPaymentProcess,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isProcessing ? deepSpaceBlue : systemCyan.withOpacity(0.15),
                    border: Border.all(
                      color: _isProcessing ? borderCyanSemi.withOpacity(0.5) : systemCyan,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.Center,
                  child: Text(
                    _isProcessing ? "[ PROCESSING DEPOSIT... ]" : "UNLOCK MEMBERSHIP KEY (₹100)",
                    style: TextStyle(
                      color: _isProcessing ? passiveGray : systemCyanGlow,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              if (_transactionStatus != null) ...[
                const SizedBox(height: 10),
                Text(
                  _transactionStatus!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _transactionStatus!.contains("CLEARED")
                        ? const Color(0xFF00FF66)
                        : coinsGold,
                    fontFamily: 'Courier',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // Owner bypass feedback controller panel
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: systemCyan.withOpacity(0.04),
                  border: Border.all(color: systemCyan.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        Text("👑 ", style: TextStyle(fontSize: 12)),
                        Text(
                          "OWNER BYPASS RECOGNITION PANEL",
                          style: TextStyle(
                            color: systemCyanGlow,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Our systems automatically grant permanent, unconditional lifetime double-S rank bypass to 'irfanlatheef7@gmail.com'.",
                      style: TextStyle(
                        color: passiveGray,
                        fontFamily: 'Courier',
                        fontSize: 8,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "CURRENT: ${widget.profile.email.toUpperCase()}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: highlightWhite,
                              fontFamily: 'Courier',
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          widget.profile.email.toLowerCase().trim() == "irfanlatheef7@gmail.com"
                              ? "BYPASS ENGAGED ✅"
                              : "EMAIL UNMATCHED ❌",
                          style: TextStyle(
                            color: widget.profile.email.toLowerCase().trim() == "irfanlatheef7@gmail.com"
                                ? const Color(0xFF00FF66)
                                : penaltyRed,
                            fontFamily: 'Courier',
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for holographic bypass portal rotating ring
class GateRingPainter extends CustomPainter {
  final double angle;
  GateRingPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final paintOuter = Paint()
      ..color = systemCyanGlow.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paintOuter);

    final paintInner = Paint()
      ..color = systemCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw dashed rotating elements programmatically
    const int segments = 12;
    final double sweepAngle = (360 / segments) * math.pi / 180;
    for (int i = 0; i < segments; i++) {
      if (i % 2 == 0) {
        final double startAngle = angle + (i * 360 / segments) * math.pi / 180;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.width / 2.8),
          startAngle,
          sweepAngle,
          false,
          paintInner,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GateRingPainter oldDelegate) =>
      oldDelegate.angle != angle;
}

// --- MODULE 1: AI POWER SCAN CAMERA ---
class AIScanScreen extends StatefulWidget {
  final UserProfile profile;
  const AIScanScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<AIScanScreen> createState() => _AIScanScreenState();
}

class _AIScanScreenState extends State<AIScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;
  String _currentMode = "SCAN_SETTINGS"; // SCAN_SETTINGS, SCANNING, RESULTS
  String _selectedPhysique = "E-Rank Starter Form";
  String _customGoal = "Break initial limits and reach Monarch tier density.";

  String _statusOutputLog = "Initializing scanner grid...";
  String _aiOutputReport = "";
  int _muscleQuality = 42;
  int _powerOutput = 120;
  String _potentialClassification = "D-Rank Potential";

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  Future<void> _executePhysiqueCalculation() async {
    setState(() {
      _currentMode = "SCANNING";
    });

    final logs = [
      "CONNECTING COGNITIVE CHANNELS...",
      "CALIBRATING TARGET MONARCH RATIO...",
      "MEASURING MUSCULAR DISPLACEMENT...",
      "RESISTIVE ADIPOSE DENSITY MAPPING...",
      "PROBING MAGIC AURA INTENSITY CELLULAR VECTORS..."
    ];

    for (var log in logs) {
      if (!mounted) return;
      setState(() {
        _statusOutputLog = log;
      });
      await Future.delayed(const Duration(milliseconds: 700));
    }

    // Connect to actual Gemini REST Endpoint
    const apiKey = "MY_GEMINI_API_KEY"; // Placeholder for runtime insertion key
    String parsedText;

    if (apiKey == "MY_GEMINI_API_KEY") {
      parsedText = """
SYSTEM ENGRAVEMENT: PHYSIQUE MATRIX CALCULATED

CURRENT PROFILE: [${_selectedPhysique.toUpperCase()}]
ESTIMATED POTENTIAL: S-RANK MONARCH DEVIATION

* SYSTEM ASSESSMENT: Cordial muscular alignment captured. Latent energy concentrated along chest fibers. Core stability evaluated at 85% apex distribution.
* PATH TO ASCENSION: Increase heavy squats load. Harden spinal integrity channels to prevent physical limits breakage.

THE SHADOW MONARCH HIGHLIGHTS YOUR RESOLVE. ARISE!
      """;
    } else {
      try {
        final url = Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=$apiKey");
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {
                    "text":
                        "Analyze physique for fitness goal: $_customGoal under simulated profile model: $_selectedPhysique. Keep it inside 4 intense sentences styled with Solo Leveling system words."
                  }
                ]
              }
            ]
          }),
        );
        final dynamic data = jsonDecode(response.body);
        parsedText = data['candidates'][0]['content']['parts'][0]['text'] ??
            "SYSTEM ERROR CALIBRATING METRIC RESPONSE.";
      } catch (e) {
        parsedText = "FALLBACK OVERRIDE: Link terminal lost. Core parameters boosted: Stamina +15, Willpower +30.";
      }
    }

    if (!mounted) return;
    setState(() {
      _aiOutputReport = parsedText;
      if (_selectedPhysique.contains("E-Rank")) {
        _muscleQuality = 42 + math.Random().nextInt(10);
        _powerOutput = 100 + math.Random().nextInt(80);
        _potentialClassification = "D-Rank Potential";
      } else if (_selectedPhysique.contains("C-Rank")) {
        _muscleQuality = 68 + math.Random().nextInt(10);
        _powerOutput = 350 + math.Random().nextInt(100);
        _potentialClassification = "B-Rank Potential";
      } else {
        _muscleQuality = 92 + math.Random().nextInt(6);
        _powerOutput = 850 + math.Random().nextInt(140);
        _potentialClassification = "S-Rank National Level Potential";
      }
      _currentMode = "RESULTS";
    });
  }

  @override
  Widget build(BuildContext context) {
    return PremiumLockWrapper(
      profile: widget.profile,
      featureName: "AI Power Scan Camera",
      child: Column(
        children: [
          _buildScreenHeader("AI POWER SCAN CAMERA"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _currentMode == "SCAN_SETTINGS"
                  ? _buildSettingsView()
                  : _currentMode == "SCANNING"
                      ? _buildScanningView()
                      : _buildResultsView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderCyanSemi, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, color: systemCyan, size: 10),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        const SystemSectionHeader(title: "[ COGNITIVE PHYSIQUE CAMERA VIEWPORT ]"),
        const SizedBox(height: 12),
        // Simulated viewfinder layout
        AnimatedBuilder(
          animation: _sweepController,
          builder: (context, child) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: borderCyanSemi, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("👤", style: TextStyle(fontSize: 54)),
                        SizedBox(height: 8),
                        Text(
                          "CAMERA FEED STABLE",
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 10,
                            color: systemCyanGlow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sweeping tracking laser line simulation
                  Positioned(
                    top: _sweepController.value * 200,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: systemCyan,
                        boxShadow: [
                          BoxShadow(
                            color: systemCyan.withOpacity(0.8),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const SystemSectionHeader(title: "[ SELECT TARGET MATRIX PHYSIQUE ]"),
        const SizedBox(height: 12),
        _buildPresetTile("E-Rank Starter Form", "Unconditioned beginner structures (LV.1-9)", "💪"),
        const SizedBox(height: 8),
        _buildPresetTile("C-Rank Monarch Form", "Hardened skeletal core configurations (LV.10-29)", "⚡"),
        const SizedBox(height: 8),
        _buildPresetTile("S-Rank Apex Form", "Shadow sovereign muscle structure mappings (LV.30+)", "👑"),
        const SizedBox(height: 20),
        // Custom objective textfield input
        const Text(
          "AWAKENING LEVELING GOAL:",
          style: TextStyle(fontFamily: 'Courier', fontSize: 10, color: coinsGold, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          style: const TextStyle(fontFamily: 'Courier', fontSize: 11),
          decoration: InputDecoration(
            fillColor: Colors.black,
            filled: true,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: systemCyan),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderCyanSemi.withOpacity(0.5)),
            ),
          ),
          controller: TextEditingController(text: _customGoal),
          onChanged: (text) => _customGoal = text,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: systemCyan.withOpacity(0.15),
            side: const BorderSide(color: systemCyan, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _executePhysiqueCalculation,
          child: const Text(
            "EXECUTE RESONATING AI SCAN",
            style: TextStyle(color: systemCyanGlow, fontFamily: 'Courier', fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPresetTile(String name, String desc, String emoji) {
    final isSelected = _selectedPhysique == name;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedPhysique = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? systemCyan.withOpacity(0.1) : deepSpaceBlue,
          border: Border.all(color: isSelected ? systemCyan : borderCyanSemi.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? highlightWhite : passiveGray,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: 'Courier',
                    ),
                  ),
                  Text(desc, style: const TextStyle(color: passiveGray, fontSize: 8, fontFamily: 'Courier')),
                ],
              ),
            ),
            if (isSelected)
              const Text(
                "● READY",
                style: TextStyle(color: Color(0xFF00FF66), fontSize: 9, fontFamily: 'Courier', fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: systemCyan, strokeWidth: 3),
          const SizedBox(height: 24),
          const Text(
            "ALIGNING PHYSICAL COEFFICIENTS",
            style: TextStyle(fontFamily: 'Courier', color: systemCyanGlow, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            _statusOutputLog,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Courier', color: passiveGray, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return ListView(
      children: [
        const SizedBox(height: 16),
        const SystemSectionHeader(title: "[ SYSTEM AWAKENED METRICS REPORT ]"),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: deepSpaceBlue,
            border: Border.all(color: borderCyanSemi),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("TACTICAL CALCULATIONS:", style: TextStyle(color: systemCyan, fontFamily: 'Courier', fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildMetricBar("MUSCULAR ALIGNMENT QUALITY", _muscleQuality, "%"),
              const SizedBox(height: 10),
              _buildMetricBar("AURA POWER GAUGE CAPACITY", _powerOutput, " pt"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("AWAKENING FORM RATING:", style: TextStyle(color: passiveGray, fontSize: 9, fontFamily: 'Courier')),
                  Text(_potentialClassification.toUpperCase(), style: const TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SystemSectionHeader(title: "[ SYSTEM ADVISORY ARCHIVE ]"),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: borderCyanSemi.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _aiOutputReport,
            style: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: highlightWhite, height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mediumSpaceBlue,
            side: const BorderSide(color: borderCyanSemi),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            setState(() {
              _currentMode = "SCAN_SETTINGS";
            });
          },
          child: const Text("RE-CALIBRATE SCANNERS", style: TextStyle(fontFamily: 'Courier', color: highlightWhite, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMetricBar(String label, int value, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: passiveGray, fontSize: 8, fontFamily: 'Courier')),
            Text("$value$suffix", style: const TextStyle(color: highlightWhite, fontSize: 10, fontFamily: 'Courier', fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value / (suffix.contains("pt") ? 1000 : 100),
            backgroundColor: obsidianBlack,
            color: suffix.contains("pt") ? coinsGold : systemCyan,
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

// --- MODULE 2: 3D HOLOGRAM COACH CONCEPT ---
class HoloCoachScreen extends StatefulWidget {
  final UserProfile profile;
  const HoloCoachScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<HoloCoachScreen> createState() => _HoloCoachScreenState();
}

class _HoloCoachScreenState extends State<HoloCoachScreen> with SingleTickerProviderStateMixin {
  late AnimationController _skeletalController;
  String _activeCoachingForm = "HOLOGRAPHIC SQUAT";

  final Map<String, List<String>> _tips = {
    "HOLOGRAPHIC SQUAT": [
      "Keep knees parallel or slightly outward.",
      "Descend until femur elements are sub-horizontal.",
      "Maintain spinal integrity vector angles perfectly upright."
    ],
    "NANOSHADOW PUSH-UP": [
      "Set shoulders and wrist targets aligned vertically.",
      "Contract core matrices to preserve spinal load distribution.",
      "Decline fully until chest range trigger is close to standard."
    ],
    "MONARCH PLANK FOCUS": [
      "Position elbow joints exactly under deltoid segments.",
      "Do not allow lumbar region to buckle or bend upwards.",
      "Focus spiritual energy along entire spinal baseline."
    ]
  };

  @override
  void initState() {
    super.initState();
    _skeletalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _skeletalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumLockWrapper(
      profile: widget.profile,
      featureName: "3D Hologram Coach Concept",
      child: Column(
        children: [
          _buildHoloHeader("3D HOLOGRAM COACH CONCEPT"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  const SystemSectionHeader(title: "[ HOLOGRAPHIC POSE CALIBRATOR FEED ]"),
                  const SizedBox(height: 12),
                  // Animated Wireframe Skeletal Canvas Viewport
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: borderCyanSemi, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _skeletalController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: SkeletalMeshPainter(
                                progress: _skeletalController.value,
                                modelType: _activeCoachingForm,
                              ),
                              child: Container(),
                            );
                          },
                        ),
                        // HUD Alignment status ticker overlay
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              border: Border.all(color: borderCyanSemi),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("ALIGNMENT", style: TextStyle(color: passiveGray, fontSize: 8, fontFamily: 'Courier')),
                                AnimatedBuilder(
                                  animation: _skeletalController,
                                  builder: (context, child) {
                                    final quality = 92.5 + (_skeletalController.value * 6.5);
                                    return Text(
                                      "${quality.toStringAsFixed(1)}%",
                                      style: const TextStyle(color: Color(0xFF00FF66), fontSize: 11, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SystemSectionHeader(title: "[ ACTIVE COACHING DEMONSTRATORS ]"),
                  const SizedBox(height: 12),
                  _buildPoseNavigatorRow(),
                  const SizedBox(height: 20),
                  const SystemSectionHeader(title: "[ TARGET EXERCISE FORM MANDATES ]"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: deepSpaceBlue,
                      border: Border.all(color: borderCyanSemi),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...(_tips[_activeCoachingForm] ?? []).asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("0${entry.key + 1}.", style: const TextStyle(color: systemCyanGlow, fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 11)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(entry.value, style: const TextStyle(fontFamily: 'Courier', fontSize: 11, height: 1.4))),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoloHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderCyanSemi, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.blur_circular_rounded, color: systemCyan, size: 12),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoseNavigatorRow() {
    final targets = ["HOLOGRAPHIC SQUAT", "NANOSHADOW PUSH-UP", "MONARCH PLANK FOCUS"];
    return Row(
      children: targets.map((item) {
        final isSelected = _activeCoachingForm == item;
        final displayLabel = item.replaceAll("HOLOGRAPHIC ", "").replaceAll(" FOCUS", "");
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _activeCoachingForm = item;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? systemCyan.withOpacity(0.15) : mediumSpaceBlue,
                  border: Border.all(color: isSelected ? systemCyan : borderCyanSemi.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  displayLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? highlightWhite : passiveGray,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Custom Painter implementing the holographic skeletal wireframe animation logic
class SkeletalMeshPainter extends CustomPainter {
  final double progress;
  final String modelType;

  SkeletalMeshPainter({required this.progress, required this.modelType});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = systemCyan.withOpacity(0.04)
      ..strokeWidth = 1;

    // Draw coordinate system lines
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(Offset(size.width * i / 5, 0), Offset(size.width * i / 5, size.height), paintGrid);
      canvas.drawLine(Offset(0, size.height * i / 5), Offset(size.width, size.height * i / 5), paintGrid);
    }

    final paintBones = Paint()
      ..color = systemCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final paintGlowJoint = Paint()
      ..color = systemCyanGlow
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    if (modelType == "HOLOGRAPHIC SQUAT") {
      final yOffset = progress * 35;
      final head = Offset(cx, cy - 60 + yOffset);
      final neck = Offset(cx, cy - 40 + yOffset);
      final waist = Offset(cx, cy + 15 + yOffset);

      final kneeR = Offset(cx - 38 - (progress * 10), cy + 45 + yOffset * 0.4);
      final kneeL = Offset(cx + 38 + (progress * 10), cy + 45 + yOffset * 0.4);

      final ankleR = Offset(cx - 30, cy + 90);
      final ankleL = Offset(cx + 30, cy + 90);

      // Render spine
      canvas.drawLine(neck, waist, paintBones);
      // Right leg segment linkages
      canvas.drawLine(waist, kneeR, paintBones);
      canvas.drawLine(kneeR, ankleR, paintBones);
      // Left leg segment linkages
      canvas.drawLine(waist, kneeL, paintBones);
      canvas.drawLine(kneeL, ankleL, paintBones);

      // Render joints glow
      canvas.drawCircle(head, 8, paintGlowJoint);
      canvas.drawCircle(kneeR, 5, paintGlowJoint);
      canvas.drawCircle(kneeL, 5, paintGlowJoint);
    } else if (modelType == "NANOSHADOW PUSH-UP") {
      final tilt = progress * 24;
      final head = Offset(cx + 50, cy - 15 + tilt);
      final shoulder = Offset(cx + 35, cy - 5 + tilt);
      final hip = Offset(cx - 15, cy + 15 + tilt * 0.6);
      final ankles = Offset(cx - 70, cy + 35);

      final elbow = Offset(cx + 15 - progress * 10, cy + 20 + tilt);
      final wrist = Offset(cx + 25, cy + 28);

      canvas.drawLine(head, ankles, paintBones);
      canvas.drawLine(shoulder, elbow, paintBones);
      canvas.drawLine(elbow, wrist, paintBones);

      canvas.drawCircle(head, 8, paintGlowJoint);
      canvas.drawCircle(elbow, 5, paintGlowJoint);
    } else {
      // PLANK with vibrating vector paths representing stress fields
      final vibrationNoise = math.sin(progress * 40) * 1.5;
      final head = Offset(cx + 60, cy - 10 + vibrationNoise);
      final shoulder = Offset(cx + 45, cy - 5 + vibrationNoise);
      final hip = Offset(cx - 10, cy - 5 + vibrationNoise * 0.5);
      final ankle = Offset(cx - 65, cy - 5);

      final elbow = Offset(cx + 45, cy + 15);
      final wrist = Offset(cx + 55, cy + 15);

      canvas.drawLine(head, ankle, paintBones);
      canvas.drawLine(shoulder, elbow, paintBones);
      canvas.drawLine(elbow, wrist, paintBones);

      canvas.drawCircle(head, 8, paintGlowJoint);
      canvas.drawCircle(hip, 6, Paint()..color = coinsGold);
    }
  }

  @override
  bool shouldRepaint(covariant SkeletalMeshPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.modelType != modelType;
}

// --- MODULE 3: ARISE SPECIALIZED WORKOUT VOICE ASSISTANT ---
class VoiceTrainerScreen extends StatefulWidget {
  final UserProfile profile;
  const VoiceTrainerScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<VoiceTrainerScreen> createState() => _VoiceTrainerScreenState();
}

class _VoiceTrainerScreenState extends State<VoiceTrainerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isListening = false;
  final List<Map<String, String>> _transcript = [
    {
      "sender": "SYSTEM",
      "text": "SPECTRUM VO-CODERS ACTIVE. Say \"ARISE\" to wake up the system, or tap the core to invoke fitness commands."
    }
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _processUserVoiceInteraction(String userPhrase) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _transcript.insert(0, {"sender": "HUNTER", "text": userPhrase});
      _isListening = false;
    });

    // Simulated short response calculation under Solo Leveling protocols
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simple Gemini offline matrix mapping or API connector
    const String trainingAdvisory =
        "SYSTEM DIRECTIVE: Perform high-tempo squats immediately to fulfill the Monarch daily objectives!";

    if (mounted) {
      setState(() {
        _transcript.insert(0, {"sender": "SYSTEM", "text": trainingAdvisory});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quickPhrases = [
      "Arise! What is my training directive?",
      "How do I unlock S-Rank Strength?",
      "Give me a gym motivation quote!",
      "Suggest a quick workout program"
    ];

    return PremiumLockWrapper(
      profile: widget.profile,
      featureName: "ARISE Gym Voice Assistant",
      child: Column(
        children: [
          _buildVoiceHeader("ARISE AI VOICE TRAINER"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Immersive Pulsing Sound Wave Core
                  InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      setState(() {
                        _isListening = !_isListening;
                      });
                      if (_isListening) {
                        Timer(const Duration(seconds: 3), () {
                          if (mounted && _isListening) {
                            _processUserVoiceInteraction("Arise! Calibrate active strength sets.");
                          }
                        });
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: borderCyanSemi, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomPaint(
                            painter: VoiceWavesPainter(
                              pulseFactor: _pulseController.value,
                              isListening: _isListening,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(height: 14),
                                Text(
                                  _isListening ? "[ SOVEREIGN COGNITIVE LISTENING... ]" : "TAP VOICE CORE MATRIX",
                                  style: TextStyle(
                                    fontFamily: 'Courier',
                                    color: _isListening ? const Color(0xFF00FF66) : systemCyanGlow,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  highlightSize: 0,
                                  child: Text(
                                    _isListening ? "Say 'Arise ...' or choose preset below" : "TTS ENGINE STABILIZED",
                                    style: const TextStyle(fontFamily: 'Courier', color: passiveGray, fontSize: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SystemSectionHeader(title: "[ QUICK ACTION PRESET PHRASES ]"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildPresetClicker(quickPhrases[0]),
                      const SizedBox(width: 8),
                      _buildPresetClicker(quickPhrases[1]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPresetClicker(quickPhrases[2]),
                      const SizedBox(width: 8),
                      _buildPresetClicker(quickPhrases[3]),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SystemSectionHeader(title: "[ TRANSCRIPT OF COGNITIVE AUDIO COMMANDS ]"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: deepSpaceBlue.withOpacity(0.4),
                        border: Border.all(color: borderCyanSemi.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        itemCount: _transcript.length,
                        itemBuilder: (context, index) {
                          final item = _transcript[index];
                          final isUser = item["sender"] == "HUNTER";
                          return _buildTranscriptMessage(item["text"] ?? "", isUser);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderCyanSemi, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic_none_sharp, color: systemCyan, size: 12),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetClicker(String text) {
    return Expanded(
      child: InkWell(
        onTap: () => _processUserVoiceInteraction(text),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mediumSpaceBlue,
            border: Border.all(color: borderCyanSemi.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 8.5,
              color: highlightWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTranscriptMessage(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isUser ? "HUNTER PROTOCOL:" : "ARISE SYSTEM:",
            style: TextStyle(
              color: isUser ? systemCyan : coinsGold,
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? systemCyan.withOpacity(0.08) : Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isUser ? borderCyanSemi.withOpacity(0.2) : Colors.transparent),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 10,
                color: isUser ? highlightWhite : passiveGray,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter detailing glowing sinusoidal core wave feedback loops
class VoiceWavesPainter extends CustomPainter {
  final double pulseFactor;
  final bool isListening;

  VoiceWavesPainter({required this.pulseFactor, required this.isListening});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    if (isListening) {
      final paintOuterWave = Paint()
        ..color = systemCyanGlow.withOpacity(0.12)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cx, cy, 50 + (pulseFactor * 32), paintOuterWave);
    }

    // Anchor node
    final paintCore = Paint()
      ..color = systemCyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(cx, cy, 18, paintCore);

    final paintMesh = Paint()
      ..color = systemCyanGlow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Direct mathematical wave string mapping
    const int resolution = 40;
    const double widthScope = 80;
    final double startX = cx - widthScope / 2;

    for (int i = 0; i < resolution; i++) {
      final fraction = i / resolution;
      final x = startX + fraction * widthScope;
      final angle = (fraction * 10) + (pulseFactor * 4 * math.pi);
      final amp = isListening ? 22 : 6;
      final y = cy + math.sin(angle) * amp;

      canvas.drawCircle(Offset(x, y), 1.5, paintMesh);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavesPainter oldDelegate) =>
      oldDelegate.pulseFactor != pulseFactor || oldDelegate.isListening != isListening;
}

// --- HELPER WORKOUT COMPONENT HEADERS ---
class SystemSectionHeader extends StatelessWidget {
  final String title;
  const SystemSectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.keyboard_double_arrow_right, color: systemCyan, size: 14),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: highlightWhite,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
