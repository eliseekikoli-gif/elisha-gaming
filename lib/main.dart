import 'package:flutter/material.dart';

void main() {
  runApp(const EnSpeakingApp());
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

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LearnScreen(),
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
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xFF0EA5E9)), label: 'Accueil'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book, color: Color(0xFF0EA5E9)), label: 'Apprendre'),
            NavigationDestination(icon: Icon(Icons.record_voice_over_outlined), selectedIcon: Icon(Icons.record_voice_over, color: Color(0xFF0EA5E9)), label: 'Speaking'),
            NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz, color: Color(0xFF0EA5E9)), label: 'Quiz'),
            NavigationDestination(icon: Icon(Icons.trending_up), selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF0EA5E9)), label: 'Progrès'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EN-SPEAKING', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.white)),
                      Text('Améliorez votre anglais parlé', style: TextStyle(fontSize: 12, color: Colors.white60)),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.alarm_on_rounded, color: Color(0xFFF59E0B)),
                onPressed: () => _showReminderDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('OBJECTIF DU JOUR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.white70)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Intermédiaire', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Conversation Fluide : Exprimer son opinion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(value: 0.65, minHeight: 8, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation(Color(0xFFF59E0B))),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('65% complété', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Text('13 / 20 min', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.play_circle_fill, size: 28),
              label: const Text('COMMENCER À APPRENDRE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session prête ! Ouvrez les onglets Apprendre ou Speaking')),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          const Text('Modules d\'apprentissage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 14),
          _moduleTile(Icons.translate, 'Vocabulaire & Mots Clés', '1 200 mots essentiels avec phonétique', const Color(0xFF38BDF8)),
          _moduleTile(Icons.record_voice_over, 'Simulation de Speaking', 'Entraînez-vous à parler à voix haute', const Color(0xFF10B981)),
          _moduleTile(Icons.menu_book, 'Grammaire & Expressions', 'Règles claires et expressions idiomatiques', const Color(0xFFA855F7)),
        ],
      ),
    );
  }

  static Widget _moduleTile(IconData icon, String title, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.18), radius: 22, child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(sub, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.alarm, color: Color(0xFFF59E0B)),
            SizedBox(width: 10),
            Text('Rappel Quotidien'),
          ],
        ),
        content: const Text(
          'Recevez un rappel chaque jour à 19h30 pour pratiquer votre conversation en anglais.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Annuler', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
            child: const Text('Activer', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rappel quotidien En-Speaking activé !')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> vocabulary = [
    {'en': 'Breakthrough', 'fr': 'Une avancée majeure', 'phonetic': '/ˈbreɪkˌθruː/'},
    {'en': 'Overcome', 'fr': 'Surmonter / Réussir malgré tout', 'phonetic': '/ˌoʊ.vɚˈkʌm/'},
    {'en': 'Reliable', 'fr': 'Fiable / Digne de confiance', 'phonetic': '/rɪˈlaɪ.ə.bəl/'},
    {'en': 'Straightforward', 'fr': 'Clair, simple et direct', 'phonetic': '/ˌstreɪtˈfɔːr.wɚd/'},
    {'en': 'Achieve', 'fr': 'Accomplir / Concrétiser', 'phonetic': '/əˈtʃiːv/'},
  ];

  final List<Map<String, String>> commonPhrases = [
    {'en': 'Could you please elaborate on that?', 'fr': 'Pourriez-vous préciser votre pensée ?'},
    {'en': 'Let’s get straight to the point.', 'fr': 'Allons droit au but.'},
    {'en': 'I couldn’t agree more.', 'fr': 'Je suis totalement d’accord.'},
    {'en': 'How does that sound to you?', 'fr': 'Qu\'est-ce que vous en pensez ?'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
              Tab(text: 'Vocabulaire'),
              Tab(text: 'Phrases Clés'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vocabulary.length,
                itemBuilder: (ctx, i) {
                  final item = vocabulary[i];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      title: Text(item['en']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['phonetic']!, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 13)),
                          Text(item['fr']!, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.volume_up, color: Color(0xFFF59E0B)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Audio : "${item['en']}"')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: commonPhrases.length,
                itemBuilder: (ctx, i) {
                  final item = commonPhrases[i];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      title: Text(item['en']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text(item['fr']!, style: const TextStyle(color: Colors.white70)),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow, color: Color(0xFF0EA5E9)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lecture : "${item['en']}"')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  bool isRecording = false;
  String feedbackText = "Appuyez sur le micro pour parler à voix haute.";
  double score = 0;

  final String targetSentence = "English gives you the power to connect with people worldwide.";

  void toggleRecord() {
    setState(() {
      if (!isRecording) {
        isRecording = true;
        feedbackText = "Enregistrement en cours... Parlez clairement.";
      } else {
        isRecording = false;
        score = 96.0;
        feedbackText = "Bravo ! Accent net et prononciation fluide (Score : 96%).";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ATELIER DE SPEAKING', style: TextStyle(fontSize: 12, letterSpacing: 1.1, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
              const SizedBox(height: 8),
              const Text('Pratique Orale Quotidienne', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
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
                    const Icon(Icons.format_quote_rounded, color: Color(0xFF0EA5E9), size: 34),
                    const SizedBox(height: 8),
                    Text(
                      targetSentence,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, height: 1.4, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '« L’anglais vous donne le pouvoir d’échanger avec le monde entier. »',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.white60, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(score > 0 ? Icons.check_circle : Icons.mic_none, color: score > 0 ? Colors.greenAccent : const Color(0xFFF59E0B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(feedbackText, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: toggleRecord,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.redAccent : const Color(0xFF0EA5E9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? Colors.redAccent : const Color(0xFF0EA5E9)).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(isRecording ? Icons.stop : Icons.mic, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(isRecording ? 'Appuyez pour analyser' : 'Appuyez pour parler', style: const TextStyle(fontSize: 13, color: Colors.white60)),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool isAnswered = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Que signifie l\'expression "Hang in there" ?',
      'options': ['Tiens bon / Ne baisse pas les bras', 'Raccroche le téléphone', 'Viens ici immédiatement', 'Attends dehors'],
      'answer': 0,
    },
    {
      'question': 'Choisissez la forme correcte : "She ____ English every morning."',
      'options': ['practice', 'practices', 'is practice', 'practicing'],
      'answer': 1,
    },
  ];

  void chooseOption(int index) {
    if (isAnswered) return;
    setState(() {
      selectedAnswer = index;
      isAnswered = true;
      if (index == questions[currentQuestion]['answer']) {
        score += 20;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        selectedAnswer = null;
        isAnswered = false;
      } else {
        currentQuestion = 0;
        selectedAnswer = null;
        isAnswered = false;
        score = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('QUESTION ${currentQuestion + 1}/${questions.length}', style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
              Text('Score: $score pts', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(q['question'], style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          ...List.generate(q['options'].length, (index) {
            Color cardColor = const Color(0xFF1E293B);
            if (isAnswered) {
              if (index == q['answer']) {
                cardColor = Colors.green.shade700;
              } else if (selectedAnswer == index) {
                cardColor = Colors.red.shade700;
              }
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => chooseOption(index),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white10,
                        child: Text(String.fromCharCode(65 + index), style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(q['options'][index], style: const TextStyle(fontSize: 15, color: Colors.white))),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          if (isAnswered)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: nextQuestion,
                child: Text(currentQuestion == questions.length - 1 ? 'RECOMMENCER' : 'SUIVANT', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VOTRE PROGRESSION', style: TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Badges & Niveaux', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Niveau', value: 'B2 Intermédiaire'),
                _StatItem(label: 'Assiduité', value: '7 Jours'),
                _StatItem(label: 'Score Quiz', value: '92%'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Badges En-Speaking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          _badgeTile(Icons.mic, 'Orateur Actif', 'Pratique orale régulière', true),
          _badgeTile(Icons.local_fire_department, 'Série Parfaite', '7 jours d\'affilée sur l\'application', true),
          _badgeTile(Icons.military_tech, 'Maître du Quiz', 'Score parfait sur 5 quiz', false),
        ],
      ),
    );
  }

  static Widget _badgeTile(IconData icon, String title, String sub, bool ok) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: ok ? const Color(0xFFF59E0B) : Colors.white10, radius: 22, child: Icon(icon, color: ok ? Colors.black : Colors.white30)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: ok ? Colors.white : Colors.white38)),
            Text(sub, style: TextStyle(fontSize: 12, color: ok ? Colors.white60 : Colors.white24)),
          ])),
          Icon(ok ? Icons.check_circle : Icons.lock, color: ok ? const Color(0xFF10B981) : Colors.white24),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0EA5E9))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white60)),
      ],
    );
  }
}
