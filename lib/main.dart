import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EliShaGamingApp());
}

class EliShaGamingApp extends StatelessWidget {
  const EliShaGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eli Sha Gaming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0E12),
        primaryColor: const Color(0xFFFFB800),
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

  final List<Widget> _screens = const [
    VerticalFeedScreen(),
    CommunityScreen(),
    PlaceholderScreen(title: "Ajouter un Contenu"),
    RankingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF16181F),
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, 0),
            _buildNavItem(Icons.forum_outlined, 1),
            // Bouton central jaune style prototype
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB800),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66FFB800),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 30),
              ),
            ),
            _buildNavItem(Icons.leaderboard_outlined, 3),
            _buildNavItem(Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFFFFB800) : Colors.grey,
        size: 26,
      ),
      onPressed: () => setState(() => _currentIndex = index),
    );
  }
}

// 1. VERTICAL FEED SCREEN (TikTok style)
class VerticalFeedScreen extends StatelessWidget {
  const VerticalFeedScreen({super.key});

  final List<Map<String, String>> posts = const [
    {
      "game": "GTA V",
      "tag": "Tuto & Secret",
      "author": "@Johnathan Alexis",
      "desc": "Comment débloquer le véhicule secret du braquage facilement ! #GTA #Tuto",
      "likes": "12.4K",
      "comments": "842",
      "color": "0xFF1A1C24"
    },
    {
      "game": "Far Cry 4",
      "tag": "Gameplay",
      "author": "@Savannah Nguyen",
      "desc": "Nettoyage d'avant-poste furtif en difficulté maximale 🔥",
      "likes": "45.8K",
      "comments": "1.2K",
      "color": "0xFF22181C"
    },
    {
      "game": "PUBG Mobile",
      "tag": "Astuce Pro",
      "author": "@EliSha_Admin",
      "desc": "Top 3 des meilleurs spots de tir pour survivre au cercle final.",
      "likes": "8.9K",
      "comments": "310",
      "color": "0xFF14201E"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Stack(
          children: [
            // Fond / Décoration vidéo
            Container(
              color: Color(int.parse(post["color"]!)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videogame_asset, size: 90, color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(
                      post["game"]!,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFB800)),
                      ),
                      child: Text(
                        post["tag"]!,
                        style: const TextStyle(color: Color(0xFFFFB800), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Header Top
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Eli Sha Gaming",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            // Actions latérales à droite
            Positioned(
              right: 16,
              bottom: 40,
              child: Column(
                children: [
                  _buildSideAction(Icons.favorite, post["likes"]!, Colors.redAccent),
                  const SizedBox(height: 20),
                  _buildSideAction(Icons.chat_bubble_rounded, post["comments"]!, Colors.white),
                  const SizedBox(height: 20),
                  _buildSideAction(Icons.share, "Partager", Colors.white),
                ],
              ),
            ),
            // Description en bas à gauche
            Positioned(
              left: 16,
              bottom: 30,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["author"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post["desc"]!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSideAction(IconData icon, String label, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}

// 2. SALONS COMMUNAUTAIRES
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  final List<Map<String, String>> rooms = const [
    {"name": "Salon GTA V & Online", "members": "1,420 membres", "icon": "🚗"},
    {"name": "Salon Mobile Gaming (PUBG, COD)", "members": "980 membres", "icon": "📱"},
    {"name": "Salon PC & Hardware", "members": "650 membres", "icon": "💻"},
    {"name": "Astuces & Tutos Eli Sha", "members": "2,100 membres", "icon": "🔥"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: const Text("Communauté & Salons"),
        backgroundColor: const Color(0xFF16181F),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Card(
            color: const Color(0xFF1A1C24),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Text(room["icon"]!, style: const TextStyle(fontSize: 28)),
              title: Text(room["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text(room["members"]!, style: const TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFFB800)),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

// 3. TABLEAU DE BORD & BADGES
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: const Text("Profil Gaming"),
        backgroundColor: const Color(0xFF16181F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFFFB800),
              child: Icon(Icons.person, size: 45, color: Colors.black),
            ),
            const SizedBox(height: 12),
            const Text(
              "Elisée Kikoli",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text("Membre VIP • Niveau 4 (XP: 1,450)", style: TextStyle(color: Color(0xFFFFB800))),
            const SizedBox(height: 24),
            // Section Badges
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Badges Débloqués", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _BadgeCard(icon: Icons.flag, title: "Pionnier", desc: "Inscrit Beta"),
                _BadgeCard(icon: Icons.star, title: "Expert GTA", desc: "5 astuces partagées"),
                _BadgeCard(icon: Icons.military_tech, title: "Stream Pro", desc: "Top contributeur"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _BadgeCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C24),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFB800), size: 30),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0E12),
      body: Center(child: Text("Classement XP des joueurs", style: TextStyle(color: Colors.white))),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      body: Center(child: Text(title, style: const TextStyle(color: Colors.white))),
    );
  }
}
