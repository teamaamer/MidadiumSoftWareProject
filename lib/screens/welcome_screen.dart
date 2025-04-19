import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool _startAnimation = false;

  // Color palette
  final Color _primaryColor = const Color(0xFF27548A);    // Dark Blue
  final Color _secondaryColor = const Color(0xFF183B4E);  // Dark Teal
  final Color _accentColor = const Color(0xFFDDA853);     // Golden Yellow
  final Color _backgroundColor = const Color(0xFFF5EEDC); // Light Beige

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStaticIcon(IconData icon, double size) {
    return Icon(
      icon,
      size: size,
      color: _accentColor.withOpacity(0.4),
    );
  }

  void _onGetStartedPressed() {
    setState(() => _startAnimation = true);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/signup');
    });
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("About Midadium", 
              style: GoogleFonts.poppins(color: _primaryColor)),
          content: Text(
            "Midadium is an educational platform that helps teachers "
            "upload structured lessons and enables students to interact "
            "with content through flashcards, summaries, and games.",
            style: GoogleFonts.poppins(color: _secondaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", 
                  style: GoogleFonts.poppins(color: _accentColor)),
            ),
          ],
        );
      },
    );
  }

  void _handleMenuSelection(String choice) {
    if (choice == 'Login') {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (choice == 'About Us') {
      _showAboutDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            Text(
              "Midadium",
              style: GoogleFonts.poppins(
                color: _backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            icon: Icon(Icons.menu, color: _primaryColor),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Login',
                child: Text('Login', 
                    style: GoogleFonts.poppins(color: _secondaryColor)),
              ),
              PopupMenuItem(
                value: 'About Us',
                child: Text('About Us', 
                    style: GoogleFonts.poppins(color: _secondaryColor)),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _primaryColor.withOpacity(0.9),
                  _secondaryColor,
                ],
              ),
            ),
          ),
          // Static background icons
          Positioned(top: -50, left: -50, child: _buildStaticIcon(Icons.school, 150)),
          Positioned(bottom: -80, right: -50, child: _buildStaticIcon(Icons.library_books, 150)),
          Positioned(top: 100, right: 30, child: _buildStaticIcon(Icons.games, 60)),
          Positioned(bottom: 150, left: 30, child: _buildStaticIcon(Icons.assignment, 60)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedOpacity(
                  opacity: _startAnimation ? 0 : 1,
                  duration: Duration(milliseconds: 500),
                  child: AnimatedScale(
                    scale: _startAnimation ? 0.9 : 1,
                    duration: Duration(milliseconds: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Text(
                              'Welcome to\nMidadium',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: _backgroundColor,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Empowering Learning, One Click at a Time',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: _backgroundColor.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _onGetStartedPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward, size: 24),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Wrap(
                          spacing: 20,
                          runSpacing: 15,
                          children: [
                            _FeaturePill(
                              icon: Icons.video_library,
                              text: 'Lesson Videos',
                              bgColor: _backgroundColor,
                              iconColor: _accentColor,
                            ),
                            _FeaturePill(
                              icon: Icons.extension,
                              text: 'Interactive Games',
                              bgColor: _backgroundColor,
                              iconColor: _accentColor,
                            ),
                            _FeaturePill(
                              icon: Icons.note_alt,
                              text: 'Smart Summaries',
                              bgColor: _backgroundColor,
                              iconColor: _accentColor,
                            ),
                            _FeaturePill(
                              icon: Icons.auto_awesome,
                              text: 'Adaptive Learning',
                              bgColor: _backgroundColor,
                              iconColor: _accentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bgColor;
  final Color iconColor;

  const _FeaturePill({
    required this.icon,
    required this.text,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // 👈 This is the fixed width
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: bgColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 👈 Centered content
        children: [
          Icon(icon, size: 18, color: iconColor),
          SizedBox(width: 8),
          Expanded( // 👈 This makes the text take available space
            child: Text(
              text,
              overflow: TextOverflow.ellipsis, 
              style: GoogleFonts.poppins(
                color: bgColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}