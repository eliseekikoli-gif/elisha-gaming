import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const EnSpeakingApp());
}

// =============================================================
// GESTIONNAIRE D'ÉTAT CENTRALISÉ (XP, NIVEAU, BADGES, RAPPELS)
// =============================================================
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  int totalPoints = 180;
  int completedLessonsCount = 2;
  int speakingCompletedCount = 1;
  int quizCompletedCount = 1;
  int streakDays = 4;
  TimeOfDay reminderTime = const TimeOfDay(hour: 19, minute: 30);
  bool reminderEnabled = true;

  final Set<String> completedLessons = {'gram_1', 'vocab_1'};

  void markLessonDone(String id) {
    if (!completedLessons.contains(id)) {
      completedLessons.add(id);
      completedLessonsCount = completedLessons.length;
      totalPoints += 50;
      notifyListeners();
    }
  }

  void addSpeakingXP(int score) {
    speakingCompletedCount++;
    totalPoints += (score / 2).round();
    notifyListeners();
  }

  void addQuizXP(int score) {
    quizCompletedCount++;
    totalPoints += score;
    notifyListeners();
  }

  void setReminder(TimeOfDay time, bool enabled) {
    reminderTime = time;
    reminderEnabled = enabled;
    notifyListeners();
  }

  double get globalProgress {
    double ratio = (completedLessonsCount * 12 + quizCompletedCount * 10 + speakingCompletedCount * 10) / 150.0;
    return ratio.clamp(0.08, 1.0);
  }

  String get cefrLevel {
    if (totalPoints < 150) return 'A1 Débutant';
    if (totalPoints < 300) return 'A2 Élémentaire';
    if (totalPoints < 500) return 'B1 Intermédiaire';
    if (totalPoints < 800) return 'B2 Avancé';
    return 'C1 Expert Bilingue';
  }
}

class EnSpeakingApp extends StatelessWidget {
  const EnSpeakingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'En-Speaking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF0EA5E9),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0EA5E9),
          secondary: Color(0xFFF59E0B),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  static _MainNavigationScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainNavigationScreenState>();

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void goToTab(int index) {
    setState(() => _currentIndex = index);
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    SpeakingScreen(),
    QuizScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          indicatorColor: const Color(0xFF0EA5E9).withOpacity(0.25),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xFF0EA5E9)), label: 'Accueil'),
            NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school, color: Color(0xFF0EA5E9)), label: 'Cours'),
            NavigationDestination(icon: Icon(Icons.record_voice_over_outlined), selectedIcon: Icon(Icons.record_voice_over, color: Color(0xFF0EA5E9)), label: 'Speaking'),
            NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz, color: Color(0xFF0EA5E9)), label: 'Quiz'),
            NavigationDestination(icon: Icon(Icons.trending_up), selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF0EA5E9)), label: 'Progrès'),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. PAGE ACCUEIL
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0EA5E9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.forum_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EN-SPEAKING', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
                          Text(state.cefrLevel, style: const TextStyle(fontSize: 12, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      state.reminderEnabled ? Icons.notifications_active : Icons.notifications_off_outlined,
                      color: state.reminderEnabled ? const Color(0xFFF59E0B) : Colors.white38,
                    ),
                    onPressed: () => _openReminderSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bannière Photo Apprentissage
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8)),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=1000&q=80',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (c, e, s) => Container(color: const Color(0xFF1E293B)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [const Color(0xFF0F172A).withOpacity(0.92), const Color(0xFF0F172A).withOpacity(0.35), Colors.transparent],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(20)),
                            child: Text('SÉRIE : ${state.streakDays} JOURS ACTIFS', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          const SizedBox(height: 8),
                          const Text('Parlez anglais couramment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${state.totalPoints} points XP cumulés', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Barre de progression connectée
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progression globale', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${(state.globalProgress * 100).toInt()}%', style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.w900, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: state.globalProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF0EA5E9)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bouton direct "Commencer"
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 30),
                  label: const Text('COMMENCER À APPRENDRE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  onPressed: () => MainNavigationScreen.of(context)?.goToTab(1),
                ),
              ),
              const SizedBox(height: 26),

              const Text('Accès Direct aux Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildTile(
                      icon: Icons.menu_book,
                      title: 'Cours & Fiches',
                      sub: '${state.completedLessonsCount} leçons finies',
                      color: const Color(0xFF38BDF8),
                      onTap: () => MainNavigationScreen.of(context)?.goToTab(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile(
                      icon: Icons.record_voice_over,
                      title: 'Speaking Vocal',
                      sub: '${state.speakingCompletedCount} sessions',
                      color: const Color(0xFF10B981),
                      onTap: () => MainNavigationScreen.of(context)?.goToTab(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTile(
                      icon: Icons.quiz,
                      title: 'Quiz en Direct',
                      sub: '${state.quizCompletedCount} validés',
                      color: const Color(0xFFF59E0B),
                      onTap: () => MainNavigationScreen.of(context)?.goToTab(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTile(
                      icon: Icons.emoji_events,
                      title: 'Trophées & Badges',
                      sub: state.cefrLevel,
                      color: const Color(0xFFA855F7),
                      onTap: () => MainNavigationScreen.of(context)?.goToTab(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTile({required IconData icon, required String title, required String sub, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.18), radius: 20, child: Icon(icon, color: color, size: 22)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(fontSize: 12, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  static void _openReminderSheet(BuildContext context) {
    final state = AppState.instance;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.alarm, color: Color(0xFFF59E0B)),
                      SizedBox(width: 10),
                      Text('Rappel Quotidien de Pratique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Activer la notification journalière'),
                    subtitle: const Text('Pour ne jamais briser votre série d\'apprentissage', style: TextStyle(fontSize: 12, color: Colors.white60)),
                    value: state.reminderEnabled,
                    activeColor: const Color(0xFF0EA5E9),
                    onChanged: (val) {
                      state.setReminder(state.reminderTime, val);
                      setModalState(() {});
                    },
                  ),
                  const Divider(color: Colors.white10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Heure du rappel'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        '${state.reminderTime.hour.toString().padLeft(2, '0')}:${state.reminderTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: state.reminderTime,
                      );
                      if (picked != null) {
                        state.setReminder(picked, state.reminderEnabled);
                        setModalState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rappel programmé à ${state.reminderTime.format(context)} avec succès !')),
                        );
                      },
                      child: const Text('CONFIRMER LE RAPPEL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// -------------------------------------------------------------
// 2. PAGE COURS & TRADUCTEUR FRANÇAIS <-> ANGLAIS
// -------------------------------------------------------------
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _tradController = TextEditingController();
  String _translationResult = "";

  final Map<String, String> dictionary = {
    'bonjour': 'Hello / Good morning',
    'merci': 'Thank you very much',
    'travail': 'Work / Employment / Job',
    'opportunite': 'Opportunity / Breakthrough',
    'succes': 'Success / Achievement',
    'apprendre': 'To learn / To master',
    'parler': 'To speak / To converse',
    'progres': 'Progress / Growth',
    'anglais': 'English language',
    'reunion': 'Meeting / Gathering',
    'confiance': 'Confidence / Self-reliance',
  };

  final List<Map<String, dynamic>> lessons = [
    {
      'id': 'gram_1',
      'title': 'Le Present Perfect en situation réelle',
      'category': 'Grammaire',
      'desc': 'Faire le pont entre votre passé et votre présent sans erreur.',
      'body': '• Past Simple : action révolue ("I lived in Paris in 2020").\n• Present Perfect : expérience sans date précise ou encore active ("I have worked on this project for 2 weeks").\n• Attention : Ne jamais utiliser de date exacte avec Present Perfect.',
    },
    {
      'id': 'vocab_1',
      'title': 'Anglais Professionnel : Mots d\'Impact',
      'category': 'Business English',
      'desc': 'Le vocabulaire des réunions, présentations et négociations.',
      'body': '• "To streamline" : Optimiser les processus.\n• "A breakthrough" : Une avancée majeure.\n• "Win-win situation" : Accord mutuellement avantageux.\n• "Keep me in the loop" : Tiens-moi informé.',
    },
    {
      'id': 'gram_2',
      'title': 'Conditionnels & Hypothèses',
      'category': 'Grammaire',
      'desc': 'Exprimer ce qui pourrait arriver avec fluidité.',
      'body': '• Type 1 (Réel) : If + Present -> Will + Base ("If I practice, I will speak fluently").\n• Type 2 (Imaginaire) : If + Past -> Would + Base ("If I had more time, I would travel").',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _translate(String val) {
    final key = val.trim().toLowerCase();
    setState(() {
      if (key.isEmpty) {
        _translationResult = "";
      } else if (dictionary.containsKey(key)) {
        _translationResult = dictionary[key]!;
      } else {
        _translationResult = "Traduction contextuelle : \"$val\" -> [En-Speaking: $val]";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Column(
      children: [
        Container(
          color: const Color(0xFF1E293B),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF0EA5E9),
            labelColor: const Color(0xFF0EA5E9),
            unselectedLabelColor: Colors.white60,
            tabs: const [
              Tab(text: 'Leçons & Cours'),
              Tab(text: 'Traducteur FR ↔ EN'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Leçons
              AnimatedBuilder(
                animation: state,
                builder: (context, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lessons.length,
                    itemBuilder: (ctx, i) {
                      final item = lessons[i];
                      final isDone = state.completedLessons.contains(item['id']);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDone ? const Color(0xFF10B981).withOpacity(0.4) : Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                  child: Text(item['category'], style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? const Color(0xFF10B981) : Colors.white30),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(item['title'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(item['desc'], style: const TextStyle(fontSize: 13, color: Colors.white70)),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(14)),
                              child: Text(item['body'], style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.white70)),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDone ? const Color(0xFF1E293B) : const Color(0xFF0EA5E9),
                                  side: BorderSide(color: isDone ? const Color(0xFF10B981) : Colors.transparent),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  state.markLessonDone(item['id']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Cours "${item['title']}" complété avec succès (+50 pts) !')),
                                  );
                                },
                                child: Text(isDone ? 'COURS COMPLÉTÉ ✓' : 'VALIDER ET GAGNER +50 PTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDone ? const Color(0xFF10B981) : Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              // Traducteur
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TRADUCTION DIRECTE', style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    const Text('Dictionnaire & Mots Clés', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tradController,
                      onChanged: _translate,
                      decoration: InputDecoration(
                        hintText: 'Tapez un mot français (ex: travail, progres, merci...)',
                        prefixIcon: const Icon(Icons.translate, color: Color(0xFF0EA5E9)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _tradController.clear();
                            _translate('');
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E293B),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_translationResult.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF0EA5E9).withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ÉQUIVALENT EN ANGLAIS', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(_translationResult, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// 3. PAGE SPEAKING / PRATIQUE ORALE & DIALOGUES
// -------------------------------------------------------------
class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  int currentIdx = 0;
  bool isRecording = false;
  bool isFinished = false;
  int recordedScore = 0;
  String feedbackMessage = "";
  Timer? waveTimer;
  double waveScale = 1.0;

  final List<Map<String, String>> dialogPhrases = [
    {
      'role': 'Entretien d\'embauche',
      'en': 'I am highly passionate about delivering innovative solutions.',
      'fr': 'Je suis profondément passionné par la conception de solutions innovantes.',
      'phonetics': 'aɪ æm ˈhaɪli ˈpæʃənət əˈbaʊt dɪˈlɪvərɪŋ ˌɪnəˈveɪtɪv səˈluːʃənz',
    },
    {
      'role': 'Au Restaurant / Voyage',
      'en': 'Could we please have the bill and some sparkling water?',
      'fr': 'Pourrions-nous avoir l\'addition et de l\'eau gazeuse s\'il vous plaît ?',
      'phonetics': 'kʊd wiː pliːz hæv ðə bɪl ænd sʌm ˈspɑːklɪŋ ˈwɔːtər',
    },
    {
      'role': 'Réunion d\'équipe',
      'en': 'Let us align on our main priorities before the deadline.',
      'fr': 'Mettons-nous d\'accord sur nos priorités principales avant la date limite.',
      'phonetics': 'lɛt ʌs əˈlaɪn ɒn ˈaʊər meɪn praɪˈɒrɪtiz bɪˈfɔːr ðə ˈdɛdlaɪn',
    },
  ];

  void toggleVoiceAnalysis() {
    setState(() {
      isRecording = true;
      isFinished = false;
      feedbackMessage = "Enregistrement en direct... Articulez chaque mot.";
    });

    waveTimer = Timer.periodic(const Duration(milliseconds: 140), (t) {
      if (!mounted) return;
      setState(() => waveScale = 0.85 + Random().nextDouble() * 0.45);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      waveTimer?.cancel();
      final score = 92 + Random().nextInt(8); // 92 à 99%
      setState(() {
        isRecording = false;
        isFinished = true;
        recordedScore = score;
        feedbackMessage = "Prononciation impeccable ! Fluidité et accent bien rythmés (Score : $score%).";
      });
      AppState.instance.addSpeakingXP(score);
    });
  }

  void nextDialogue() {
    setState(() {
      currentIdx = (currentIdx + 1) % dialogPhrases.length;
      isFinished = false;
      recordedScore = 0;
      feedbackMessage = "Lisez la phrase et appuyez sur le micro.";
    });
  }

  @override
  void dispose() {
    waveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = dialogPhrases[currentIdx];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF0EA5E9).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text(current['role']!, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  IconButton(icon: const Icon(Icons.skip_next, color: Color(0xFF0EA5E9)), onPressed: nextDialogue),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Simulation de Speaking', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),

              // Carte Phrase
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF0EA5E9).withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Text(
                      current['en']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.4, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      current['phonetics']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF38BDF8), fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '« ${current['fr']} »',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Feedback en direct
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(isFinished ? Icons.verified : Icons.info_outline, color: isFinished ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feedbackMessage.isEmpty ? "Appuyez sur le micro pour évaluer votre prononciation." : feedbackMessage,
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Micro animé
          Column(
            children: [
              Transform.scale(
                scale: isRecording ? waveScale : 1.0,
                child: GestureDetector(
                  onTap: isRecording ? null : toggleVoiceAnalysis,
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.redAccent : const Color(0xFF0EA5E9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? Colors.redAccent : const Color(0xFF0EA5E9)).withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(isRecording ? Icons.graphic_eq : Icons.mic, size: 42, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(isRecording ? 'Analyse vocale en cours...' : 'Appuyer pour parler à voix haute', style: const TextStyle(fontSize: 13, color: Colors.white60)),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. PAGE QUIZ & CALCUL DES SCORES
// -------------------------------------------------------------
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQ = 0;
  int sessionScore = 0;
  int? pickedIdx;
  bool isAnswered = false;

  final List<Map<String, dynamic>> quizItems = [
    {
      'question': 'Quelle phrase illustre un Present Perfect correct ?',
      'options': [
        'I have visited London three times.',
        'I have visited London yesterday.',
        'I was visited London last summer.',
        'I am visit London regularly.'
      ],
      'answer': 0,
      'explanation': 'Le Present Perfect exprime une expérience de vie sans mention d\'une date révolue spécifique.',
    },
    {
      'question': 'Que signifie l\'expression : "To think outside the box" ?',
      'options': [
        'Penser avec créativité et innovation',
        'Sortir immédiatement du bureau',
        'Ranger des documents dans une boîte',
        'Refuser une proposition'
      ],
      'answer': 0,
      'explanation': 'C\'est une métaphore célèbre pour inviter à trouver des solutions originales.',
    },
    {
      'question': 'Complétez : "If I ____ more time, I would master English faster."',
      'options': ['have', 'had', 'will have', 'having'],
      'answer': 1,
      'explanation': 'Conditionnel de type 2 (hypothèse) : If + Past Simple -> Would + Base verbale.',
    },
  ];

  void onSelect(int index) {
    if (isAnswered) return;
    setState(() {
      pickedIdx = index;
      isAnswered = true;
      if (index == quizItems[currentQ]['answer']) {
        sessionScore += 30;
      }
    });
  }

  void nextStep() {
    setState(() {
      if (currentQ < quizItems.length - 1) {
        currentQ++;
        pickedIdx = null;
        isAnswered = false;
      } else {
        AppState.instance.addQuizXP(sessionScore);
        currentQ = 0;
        pickedIdx = null;
        isAnswered = false;
        sessionScore = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = quizItems[currentQ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('QUESTION ${currentQ + 1}/${quizItems.length}', style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
              Text('Score : $sessionScore pts', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(q['question'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 18),
          ...List.generate(q['options'].length, (index) {
            Color cardBg = const Color(0xFF1E293B);
            if (isAnswered) {
              if (index == q['answer']) {
                cardBg = Colors.green.shade700;
              } else if (pickedIdx == index) {
                cardBg = Colors.red.shade700;
              }
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white10,
                        child: Text(String.fromCharCode(65 + index), style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(q['options'][index], style: const TextStyle(fontSize: 14, color: Colors.white))),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (isAnswered) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(q['explanation'], style: const TextStyle(fontSize: 12, color: Colors.white70))),
                ],
              ),
            ),
          ],
          const Spacer(),
          if (isAnswered)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: nextStep,
                child: Text(currentQ == quizItems.length - 1 ? 'ENREGISTRER LE SCORE (+XP)' : 'QUESTION SUIVANTE', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. PAGE PROGRESSION & BADGES DÉBLOQUÉS
// -------------------------------------------------------------
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('VOTRE PROGRESSION EN DIRECT', style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Niveaux & Récompenses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCol(label: 'Niveau Global', value: state.cefrLevel),
                    _StatCol(label: 'Points XP', value: '${state.totalPoints} pts'),
                    _StatCol(label: 'Série', value: '${state.streakDays} Jours'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Badges Débloqués', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              _badgeTile(Icons.school, 'Étudiant Actif', 'A complété au moins 2 leçons', state.completedLessonsCount >= 2),
              _badgeTile(Icons.mic, 'Orateur Engagé', 'A pratiqué la prononciation', state.speakingCompletedCount >= 1),
              _badgeTile(Icons.emoji_events, 'Maître du Quiz', 'A accumulé plus de 200 points XP', state.totalPoints >= 200),
              _badgeTile(Icons.military_tech, 'Bilingue Élite', 'Atteindre le niveau C1 Expert', state.totalPoints >= 800),
            ],
          ),
        );
      },
    );
  }

  static Widget _badgeTile(IconData icon, String title, String sub, bool unlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFF1E293B) : const Color(0xFF1E293B).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: unlocked ? const Color(0xFFF59E0B).withOpacity(0.5) : Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: unlocked ? const Color(0xFFF59E0B) : Colors.white10,
            radius: 22,
            child: Icon(icon, color: unlocked ? Colors.black : Colors.white30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: unlocked ? Colors.white : Colors.white38)),
                Text(sub, style: TextStyle(fontSize: 12, color: unlocked ? Colors.white60 : Colors.white24)),
              ],
            ),
          ),
          Icon(unlocked ? Icons.check_circle : Icons.lock, color: unlocked ? const Color(0xFF10B981) : Colors.white24),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String label;
  final String value;
  const _StatCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0EA5E9))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
      ],
    );
  }
}
