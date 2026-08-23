import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    const VerticalVideoFeedScreen(),
    const CommunityScreen(),
    const SizedBox.shrink(),
    const RankingScreen(),
    const ProfileScreen(),
  ];

  void _openCreatePostModal() {
    final titleController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16181F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Publier un Clip Gaming",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Titre du tuto, jeu ou astuce...",
                  hintStyle: TextStyle(color: Colors.white38),
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
                label: const Text("Uploader le Clip (+50 XP)", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Clip envoyé avec succès ! Il sera validé par la communauté.")),
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
        height: 65,
        decoration: const BoxDecoration(
          color: Color(0xFF16181F),
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, 0, "Feed"),
            _buildNavItem(Icons.forum_outlined, 1, "Salons"),
            GestureDetector(
              onTap: _openCreatePostModal,
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB800),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Color(0x66FFB800), blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 28),
              ),
            ),
            _buildNavItem(Icons.leaderboard_outlined, 3, "Classement"),
            _buildNavItem(Icons.person_outline, 4, "Profil"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFFFB800) : Colors.grey, size: 24),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFFFFB800) : Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

// LECTEUR VIDÉO TIKTOK STREAMING
class VerticalVideoFeedScreen extends StatefulWidget {
  const VerticalVideoFeedScreen({super.key});

  @override
  State<VerticalVideoFeedScreen> createState() => _VerticalVideoFeedScreenState();
}

class _VerticalVideoFeedScreenState extends State<VerticalVideoFeedScreen> {
  final PageController _pageController = PageController();
  int _focusedIndex = 0;

  final List<Map<String, dynamic>> _videos = [
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-hands-of-a-gamer-playing-video-game-41584-large.mp4",
      "author": "@EliSha_Admin",
      "title": "Setup Gaming & Astuces Manette Pro 🔥 #Gameplay #Tips",
      "likes": 14200,
      "comments": 340,
      "shares": 120,
      "isLiked": false,
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-player-losing-a-video-game-41586-large.mp4",
      "author": "@GamerPro_243",
      "title": "Quand le boss final a 1 HP mais que tu meurs quand même... 💀 #Fail #Gaming",
      "likes": 28400,
      "comments": 912,
      "shares": 540,
      "isLiked": false,
    },
    {
      "url": "https://assets.mixkit.co/videos/preview/mixkit-young-man-playing-video-games-41585-large.mp4",
      "author": "@Valkyrie_COD",
      "title": "Top 1 Battle Royale avec le dernier sniper débloqué ! 🎯",
      "likes": 8750,
      "comments": 215,
      "shares": 95,
      "isLiked": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (index) {
          setState(() {
            _focusedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return SingleVideoPlayer(
            videoData: _videos[index],
            play: _focusedIndex == index,
          );
        },
      ),
    );
  }
}

class SingleVideoPlayer extends StatefulWidget {
  final Map<String, dynamic> videoData;
  final bool play;
  const SingleVideoPlayer({super.key, required this.videoData, required this.play});

  @override
  State<SingleVideoPlayer> createState() => _SingleVideoPlayerState();
}

class _SingleVideoPlayerState extends State<SingleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoData["url"]))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          if (widget.play) {
            _controller.play();
          }
        }
      });
  }

  @override
  void didUpdateWidget(covariant SingleVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInitialized) {
      if (widget.play) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  void _onDoubleTap() {
    setState(() {
      if (!widget.videoData["isLiked"]) {
        widget.videoData["isLiked"] = true;
        widget.videoData["likes"] += 1;
      }
      _showHeartAnimation = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFB800)),
                ),

          // Animation coeur double tap
          if (_showHeartAnimation)
            const Center(
              child: Icon(Icons.favorite, color: Colors.redAccent, size: 100),
            ),

          // Overlay Pause
          if (_isInitialized && !_controller.value.isPlaying && !_showHeartAnimation)
            const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white54, size: 70),
            ),

          // En-tête Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Eli Sha Gaming",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: [
                      Shadow(color: Colors.black, blurRadius: 4)
                    ]),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Recherche de clips & salons...")),
                      );
                    },
                  )
                ],
              ),
            ),
          ),

          // Actions à droite (Like, Comment, Share)
          Positioned(
            right: 12,
            bottom: 40,
            child: Column(
              children: [
                _buildActionItem(
                  icon: Icons.favorite,
                  color: widget.videoData["isLiked"] ? Colors.red : Colors.white,
                  label: "${widget.videoData["likes"]}",
                  onTap: () {
                    setState(() {
                      widget.videoData["isLiked"] = !widget.videoData["isLiked"];
                      widget.videoData["likes"] += widget.videoData["isLiked"] ? 1 : -1;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  icon: Icons.chat_bubble_rounded,
                  color: Colors.white,
                  label: "${widget.videoData["comments"]}",
                  onTap: () => _openComments(context),
                ),
                const SizedBox(height: 16),
                _buildActionItem(
                  icon: Icons.share,
                  color: Colors.white,
                  label: "${widget.videoData["shares"]}",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lien du clip partagé !")),
                    );
                  },
                ),
              ],
            ),
          ),

          // Description & Auteur en bas à gauche
          Positioned(
            left: 16,
            bottom: 25,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.videoData["author"],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, shadows: [
                    Shadow(color: Colors.black, blurRadius: 4)
                  ]),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.videoData["title"],
                  style: const TextStyle(color: Colors.white, fontSize: 13, shadows: [
                    Shadow(color: Colors.black, blurRadius: 4)
                  ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, shadows: [
              Shadow(color: Colors.black, blurRadius: 4)
            ]),
          )
        ],
      ),
    );
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16181F),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Commentaires en direct", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white10),
              const Expanded(
                child: Center(
                  child: Text("Rejoignez la discussion !", style: TextStyle(color: Colors.white38)),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Ajouter un commentaire...",
                  filled: true,
                  fillColor: const Color(0xFF1A1C24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  suffixIcon: const Icon(Icons.send, color: Color(0xFFFFB800)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// SALONS & COMMUNAUTÉ
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  final List<Map<String, String>> rooms = const [
    {"name": "Salon GTA V & Braquages", "members": "1,420 en ligne", "icon": "🚗"},
    {"name": "Salon Mobile Gaming (PUBG, COD)", "members": "980 en ligne", "icon": "📱"},
    {"name": "Salon PC & Hardware", "members": "650 en ligne", "icon": "💻"},
    {"name": "Astuces & Tutos Eli Sha", "members": "2,100 en ligne", "icon": "🔥"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: const Text("Salons & Communauté"),
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
              subtitle: Text(room["members"]!, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFFB800)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoomChatScreen(roomName: room["name"]!)),
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
    {"user": "Admin Eli Sha", "text": "Bienvenue dans le salon ! Partagez vos astuces et posez vos questions.", "isMe": "false"}
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

// PROFIL & CLASSEMENT
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E12),
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: const Color(0xFF16181F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFFFB800),
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 12),
            const Text("Elisée Kikoli", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Créateur Pro • Niveau 4 (1,450 XP)", style: TextStyle(color: Color(0xFFFFB800))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat("12", "Vidéos"),
                _buildStat("3.2k", "Abonnés"),
                _buildStat("45.1k", "Likes"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String val, String title) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

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
        title: const Text("Top Joueurs"),
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
