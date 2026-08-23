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

  final List<Widget> _screens = [
    const VerticalFeedScreen(),
    const CommunityScreen(),
    const SizedBox.shrink(),
    const RankingScreen(),
    const ProfileScreen(),
  ];

  void _openCreatePostModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16181F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final textController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Publier un Clip / Tuto",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Titre de l'astuce ou lien vidéo...",
                  filled: true,
                  fillColor: Color(0xFF1A1C24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                ),
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Partager avec la communauté", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Publication partagée avec succès ! +50 XP")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
            GestureDetector(
              onTap: _openCreatePostModal,
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

// 1. VERTICAL FEED INTERACTIF
class VerticalFeedScreen extends StatefulWidget {
  const VerticalFeedScreen({super.key});

  @override
  State<VerticalFeedScreen> createState() => _VerticalFeedScreenState();
}

class _VerticalFeedScreenState extends State<VerticalFeedScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      "game": "GTA V",
      "tag": "Tuto & Secret",
      "author": "@Johnathan Alexis",
      "desc": "Comment débloquer le véhicule secret du braquage facilement ! #GTA #Tuto",
      "likes": 12400,
      "isLiked": false,
      "comments": 842,
      "color": 0xFF1A1C24
    },
    {
      "game": "Far Cry 4",
      "tag": "Gameplay",
      "author": "@Savannah Nguyen",
      "desc": "Nettoyage d'avant-poste furtif en difficulté maximale 🔥",
      "likes": 45800,
      "isLiked": false,
      "comments": 1200,
      "color": 0xFF22181C
    },
    {
      "game": "PUBG Mobile",
      "tag": "Astuce Pro",
      "author": "@EliSha_Admin",
      "desc": "Top 3 des meilleurs spots de tir pour survivre au cercle final.",
      "likes": 8900,
      "isLiked": false,
      "comments": 310,
      "color": 0xFF14201E
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
            Container(
              color: Color(post["color"]),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videogame_asset, size: 90, color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(
                      post["game"],
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
                        post["tag"],
                        style: const TextStyle(color: Color(0xFFFFB800), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Eli Sha Gaming", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aucune notification pour le moment.")));
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 40,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        post["isLiked"] = !post["isLiked"];
                        post["likes"] += post["isLiked"] ? 1 : -1;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                          child: Icon(Icons.favorite, color: post["isLiked"] ? Colors.red : Colors.white, size: 26),
                        ),
                        const SizedBox(height: 4),
                        Text("${post["likes"]}", style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _showCommentsModal(context, post["game"]);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                          child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 4),
                        Text("${post["comments"]}", style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lien du clip copié !")));
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle, border: Border.all(color: Colors.white10)),
                          child: const Icon(Icons.share, color: Colors.white, size: 26),
                        ),
                        const SizedBox(height: 4),
                        const Text("Partager", style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 30,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post["author"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(post["desc"], style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCommentsModal(BuildContext context, String game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16181F),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Commentaires • $game", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const Divider(color: Colors.white12),
              const Expanded(
                child: Center(child: Text("Soyez le premier à réagir !", style: TextStyle(color: Colors.white54))),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 2. SALONS COMMUNAUTAIRES AVEC CHAT FONCTIONNEL
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomChatScreen(roomName: room["name"]!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class RoomChatScreen extends StatefulWidget {
  final String roomName;
  const RoomChatScreen({super.key, required this.roomName});

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final List<Map<String, String>> messages = [
    {"user": "Admin Eli Sha", "text": "Bienvenue dans le salon ! Partagez vos astuces ici.", "isMe": "false"}
  ];
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        "user": "Elisée Kikoli",
        "text": _msgController.text.trim(),
        "isMe": "true"
      });
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: const Color(0xFF16181F),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"] == "true";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFFFB800) : const Color(0xFF1A1C24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg["user"]!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.black87 : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg["text"]!,
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF16181F),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: "Écrire un message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFFFB800)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
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
            const Text("Elisée Kikoli", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Membre VIP • Niveau 4 (XP: 1,450)", style: TextStyle(color: Color(0xFFFFB800))),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Badges Débloqués", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBadge(context, Icons.flag, "Pionnier", "Inscrit Beta"),
                _buildBadge(context, Icons.star, "Expert GTA", "5 astuces"),
                _buildBadge(context, Icons.military_tech, "Stream Pro", "Top créateur"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String title, String desc) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Badge $title débloqué et actif !")),
        );
      },
      child: Container(
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
      ),
    );
  }
}

// 4. CLASSEMENT XP
class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  final List<Map<String, String>> leaderboard = const [
    {"rank": "1", "name": "ShadowGamer_99", "xp": "12,450 XP"},
    {"rank": "2", "name": "Elisée Kikoli", "xp": "8,920 XP"},
    {"rank": "3", "name": "Valkyrie_COD", "xp": "7,100 XP"},
    {"rank": "4", "name": "GamerKinshasa", "xp": "5,400 XP"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: const Text("Classement Général"),
        backgroundColor: const Color(0xFF16181F),
      ),
      body: ListView.builder(
        itemCount: leaderboard.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final player = leaderboard[index];
          final isTop = index == 0;
          return Card(
            color: const Color(0xFF1A1C24),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isTop ? const Color(0xFFFFB800) : Colors.white12,
                child: Text(player["rank"]!, style: TextStyle(color: isTop ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text(player["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              trailing: Text(player["xp"]!, style: const TextStyle(color: Color(0xFFFFB800), fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}
