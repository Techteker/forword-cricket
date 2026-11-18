import 'package:flutter/material.dart';
import '../app.dart';
import 'secondary_screens.dart';
import '../services/cricket_repository.dart';
import '../services/appwrite_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  bool ageConfirmed = false;

  static const nav = [
    (Icons.home_rounded, 'Home'),
    (Icons.sports_cricket_rounded, 'Matches'),
    (Icons.quiz_rounded, 'Quiz'),
    (Icons.newspaper_rounded, 'News'),
    (Icons.card_giftcard_rounded, 'Gifts'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _matches(),
      _quizHub(),
      _news(),
      _gifts(),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.sports_cricket, size: 21),
            ),
            const SizedBox(width: 10),
            const Text('FORWORD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3)),
            const SizedBox(width: 4),
            const Text('CRICKET', style: TextStyle(color: gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _message('You are all caught up!'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => _profile(),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'More features',
            icon: const Icon(Icons.grid_view_rounded),
            onSelected: (value) {
              if (value == 'more') {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MoreFeaturesScreen()));
              } else if (value == 'leaderboard') {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const LeaderboardScreen()));
              } else if (value == 'rules') {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const ContestRulesScreen()));
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'more', child: Text('All pages & features')),
              PopupMenuItem(value: 'leaderboard', child: Text('Leaderboard')),
              PopupMenuItem(value: 'rules', child: Text('Contest rules')),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        backgroundColor: panel,
        indicatorColor: red.withValues(alpha: .18),
        destinations: [
          for (final item in nav)
            NavigationDestination(icon: Icon(item.$1), label: item.$2),
        ],
      ),
    );
  }

  Widget _home() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFF21151B), borderRadius: BorderRadius.circular(12), border: Border.all(color: red.withValues(alpha: .25))),
          child: const Row(children: [
            Icon(Icons.bolt_rounded, color: gold, size: 17), SizedBox(width: 8),
            Text('LATEST', style: TextStyle(color: red, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
            SizedBox(width: 10), Expanded(child: Text('Your daily destination for everything cricket', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right_rounded, color: muted, size: 18),
          ]),
        ),
        const SizedBox(height: 18),
        Container(
          height: 280, clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF76202D), Color(0xFF321722), Color(0xFF121722)]), border: Border.all(color: const Color(0xFF63303A))),
          child: Stack(children: [
            Positioned(right: -20, top: 12, child: Icon(Icons.sports_cricket_rounded, size: 190, color: Colors.white.withValues(alpha: .055))),
            Positioned(right: 16, bottom: 15, child: Icon(Icons.sports_cricket_rounded, size: 112, color: gold.withValues(alpha: .13))),
            Padding(padding: const EdgeInsets.all(21), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(7)), child: const Text('THE CRICKET HUB', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.1))),
              const Spacer(),
              const Text('MORE THAN\nJUST A GAME.', style: TextStyle(fontSize: 30, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -.5)),
              const SizedBox(height: 9),
              const SizedBox(width: 245, child: Text('Real stories. Match insights. Quizzes that test your cricket brain.', style: TextStyle(color: Color(0xFFE3D9DD), fontSize: 12, height: 1.45))),
              const SizedBox(height: 15),
              Row(children: [
                FilledButton(style: FilledButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white), onPressed: () => setState(() => tab = 2), child: const Text('Take the quiz')),
                const SizedBox(width: 8), TextButton(onPressed: () => setState(() => tab = 3), child: const Text('Explore news', style: TextStyle(color: Colors.white))),
              ]),
            ])),
          ]),
        ),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('MATCH CENTRE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
          TextButton(onPressed: () => setState(() => tab = 1), child: const Text('All matches')),
        ]),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: gold.withValues(alpha: .13), borderRadius: BorderRadius.circular(6)), child: const Text('UPCOMING', style: TextStyle(color: gold, fontSize: 9, fontWeight: FontWeight.w900))),
            const Spacer(), const Text('DEMO FIXTURE', style: TextStyle(color: muted, fontSize: 9, letterSpacing: .8)),
          ]),
          const SizedBox(height: 17),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _team('IND'),
            const Column(children: [Text('VS', style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w900)), SizedBox(height: 5), Text('ODI', style: TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.w800))]),
            _team('AUS'),
          ]),
          const SizedBox(height: 12), const Text('India vs Australia • Schedule to be connected', style: TextStyle(color: muted, fontSize: 10)),
        ]))),
        const SizedBox(height: 22),
        const Text('EXPLORE CRICKET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
        const SizedBox(height: 12),
        SizedBox(height: 92, child: ListView(scrollDirection: Axis.horizontal, children: [
          _exploreTile(Icons.newspaper_rounded, 'News', red, () => setState(() => tab = 3)),
          _exploreTile(Icons.query_stats_rounded, 'Stats', gold, () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MoreFeaturesScreen()))),
          _exploreTile(Icons.groups_rounded, 'Teams', Colors.lightBlueAccent, () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MoreFeaturesScreen()))),
          _exploreTile(Icons.person_search_rounded, 'Players', Colors.greenAccent, () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MoreFeaturesScreen()))),
          _exploreTile(Icons.video_library_rounded, 'Videos', Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const MoreFeaturesScreen()))),
        ])),
        const SizedBox(height: 23),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('DAILY CRICKET QUIZ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
          const Text('FREE ENTRY', style: TextStyle(color: gold, fontSize: 9, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 11),
        Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20), border: Border.all(color: red.withValues(alpha: .35))), child: Row(children: [
          Container(width: 54, height: 58, decoration: BoxDecoration(color: red.withValues(alpha: .14), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.quiz_rounded, color: red, size: 29)),
          const SizedBox(width: 13),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ready for the challenge?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            SizedBox(height: 5), Text('Test your knowledge • 5 questions • Physical gifts', style: TextStyle(color: muted, fontSize: 10, height: 1.35)),
          ])),
          IconButton.filled(onPressed: () => setState(() => tab = 2), style: IconButton.styleFrom(backgroundColor: red), icon: const Icon(Icons.arrow_forward_rounded, size: 18)),
        ])),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('TOP STORIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
          TextButton(onPressed: () => setState(() => tab = 3), child: const Text('View all')),
        ]),
        _editorialStory('INDIA • TEAM NEWS', 'The big talking points shaping India’s next cricket chapter', Icons.flag_rounded, red),
        _editorialStory('ANALYSIS • EXPLAINER', 'Powerplay to death overs: understand the tactics behind every phase', Icons.insights_rounded, gold),
        _editorialStory('RECORDS • HISTORY', 'Iconic cricket moments that changed the game forever', Icons.military_tech_rounded, Colors.lightBlueAccent),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: const Color(0xFF201D17), borderRadius: BorderRadius.circular(18), border: Border.all(color: gold.withValues(alpha: .22))), child: Row(children: [
          const Icon(Icons.emoji_events_rounded, color: gold, size: 34), const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('KNOWLEDGE DESERVES RECOGNITION', style: TextStyle(color: gold, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .7)),
            SizedBox(height: 5), Text('Climb the leaderboard and qualify for cricket merchandise.', style: TextStyle(fontSize: 11, height: 1.4)),
          ])),
          IconButton(onPressed: _leaderboard, icon: const Icon(Icons.chevron_right_rounded, color: gold)),
        ])),
        const SizedBox(height: 20),
        const Center(child: Text('NEWS • KNOWLEDGE • CRICKET CULTURE', style: TextStyle(color: muted, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w800))),
      ],
    );
  }

  Widget _exploreTile(IconData icon, String label, Color color, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 10),
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(15), child: Container(
      width: 82, padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF252D3A))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 24), const SizedBox(height: 7),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
      ]),
    )),
  );

  Widget _editorialStory(String category, String title, IconData icon, Color color) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => setState(() => tab = 3), child: Padding(
      padding: const EdgeInsets.all(13),
      child: Row(children: [
        Container(width: 74, height: 76, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withValues(alpha: .3), const Color(0xFF202938)])), child: Icon(icon, color: color, size: 30)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(category, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .8)),
          const SizedBox(height: 6), Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5), const Text('EDITORIAL PREVIEW • READ MORE', style: TextStyle(color: muted, fontSize: 8, letterSpacing: .5)),
        ])),
        const Icon(Icons.chevron_right_rounded, color: muted),
      ]),
    )),
  );

  Widget _matches() => FutureBuilder<List<Map<String, dynamic>>>(
    future: CricketRepository.instance.getMatches(),
    builder: (context, snapshot) {
      final rows = snapshot.data ?? const <Map<String, dynamic>>[];
      return ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _pageHeading('Matches', 'Fixtures, match centres and cricket updates.'),
          const SizedBox(height: 16),
          if (snapshot.connectionState == ConnectionState.waiting)
            const LinearProgressIndicator(color: red),
          if (rows.isNotEmpty)
            for (final row in rows)
              _matchCard(
                (row['teamA'] ?? 'TBD').toString(),
                (row['teamB'] ?? 'TBD').toString(),
                (row['title'] ?? '${row['teamA'] ?? 'Team A'} vs ${row['teamB'] ?? 'Team B'}').toString(),
                (row['startsAt'] ?? row['scoreSummary'] ?? 'Match details').toString(),
                (row['status'] ?? 'SCHEDULED').toString().toUpperCase(),
              )
          else ...[
            _matchCard('IND', 'AUS', 'India vs Australia', 'Sample fixture • configure Appwrite matches table', 'DEMO'),
            const SizedBox(height: 12),
            _matchCard('MI', 'CSK', 'Mumbai vs Chennai', 'IPL sample • configure live score provider', 'DEMO'),
            const SizedBox(height: 12),
            _note('These are sample fixtures. Add your Appwrite matches table and an approved cricket data provider for real schedules and scores.'),
          ],
        ],
      );
    },
  );

  Widget _quizHub() => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      _pageHeading('Daily Cricket Quiz', 'One entry per quiz. No entry fee.'),
      const SizedBox(height: 18),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22), border: Border.all(color: red.withValues(alpha: .4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('TODAY’S CHALLENGE', style: TextStyle(color: gold, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          const Text('How well do you know international cricket?', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('10 questions  •  1 attempt  •  Free entry', style: TextStyle(color: muted)),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: _startQuiz,
            child: const Text('Start quiz'),
          )),
        ]),
      ),
      const SizedBox(height: 20),
      _sectionTitle('How it works', null, null),
      _step('01', 'Answer cricket questions', 'Use your knowledge. No purchase or payment required.'),
      _step('02', 'Get your score', 'Your score is calculated after submission.'),
      _step('03', 'Climb the leaderboard', 'Eligible top performers can qualify for physical gifts under official rules.'),
      _note('Quiz content and scoring shown here are sample content. Production attempts and rankings must be validated on a trusted backend.'),
    ],
  );

  Widget _news() => FutureBuilder<List<Map<String, dynamic>>>(
    future: CricketRepository.instance.getPublishedNews(),
    builder: (context, snapshot) {
      final rows = snapshot.data ?? const <Map<String, dynamic>>[];
      return ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _pageHeading('Cricket News', 'Short reads. Big moments.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['All', 'Team India', 'IPL', 'International', 'Records']
                .map((item) => Chip(label: Text(item), backgroundColor: panel))
                .toList(),
          ),
          if (snapshot.connectionState == ConnectionState.waiting)
            const LinearProgressIndicator(color: red),
          if (rows.isNotEmpty)
            for (final row in rows)
              _newsTile(
                (row['title'] ?? 'Cricket update').toString(),
                '${(row['sourceName'] ?? row['category'] ?? 'CRICKET').toString().toUpperCase()} • ${(row['publishedAt'] ?? '').toString()}',
                articleId: (row[r'$id'] ?? row['articleId'] ?? row['title'] ?? '').toString(),
              )
          else ...[
            _newsTile('India prepare for a high-intensity limited-overs series', 'SAMPLE • TEAM INDIA'),
            _newsTile('Young stars to watch in the upcoming domestic season', 'SAMPLE • CRICKET'),
            _newsTile('A look back at five unforgettable World Cup moments', 'SAMPLE • HISTORY'),
            _note('News cards are sample content. Connect the news_articles table and approved RSS/API ingestion to publish verified articles.'),
          ],
        ],
      );
    },
  );

  Widget _gifts() => FutureBuilder<List<Map<String, dynamic>>>(
    future: CricketRepository.instance.getGiftCatalog(),
    builder: (context, snapshot) {
      final rows = snapshot.data ?? const <Map<String, dynamic>>[];
      return ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _pageHeading('Rewards & Gifts', 'Knowledge wins. Gifts are physical.'),
          const SizedBox(height: 14),
          if (snapshot.connectionState == ConnectionState.waiting)
            const LinearProgressIndicator(color: red),
          if (rows.isNotEmpty)
            for (final row in rows)
              _giftCard(
                Icons.card_giftcard_rounded,
                (row['title'] ?? 'Cricket gift').toString(),
                (row['description'] ?? 'Physical reward • subject to official rules').toString(),
              )
          else ...[
            _giftCard(Icons.checkroom_rounded, 'Cricket Jersey', 'Sample reward • subject to availability'),
            _giftCard(Icons.sports_cricket_rounded, 'Cricket Bat', 'Sample reward • subject to availability'),
            _giftCard(Icons.sports_baseball_rounded, 'Team Cap', 'Sample reward • subject to availability'),
            _note('Sample gift catalog. Connect the gift_catalog table, stock management and winner fulfilment workflow before launch.'),
          ],
          const SizedBox(height: 12),
          _note('No cash prizes, wallet, deposits or withdrawals. Gift stock, winner verification and delivery must be managed by the app team under published rules.'),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _leaderboard,
            icon: const Icon(Icons.leaderboard),
            label: const Text('View leaderboard'),
          ),
        ],
      );
    },
  );

  Widget _sectionTitle(String title, String? action, VoidCallback? onTap) => Row(children: [
    Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
    if (action != null) TextButton(onPressed: onTap, child: Text(action)),
  ]);

  Widget _matchCard(String a, String b, String title, String subtitle, String status) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.sports_cricket, color: gold, size: 17),
          const SizedBox(width: 7),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(status, style: TextStyle(color: status == 'UPCOMING' ? gold : muted, fontSize: 9, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 17),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _team(a), const Text('VS', style: TextStyle(color: muted, fontWeight: FontWeight.w900)), _team(b),
        ]),
        const SizedBox(height: 12),
        Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      ]),
    ),
  );

  Widget _team(String name) => Column(children: [
    CircleAvatar(radius: 23, backgroundColor: const Color(0xFF252D3A), child: Text(name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.w900, color: gold))),
    const SizedBox(height: 7),
    Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
  ]);

  Widget _newsTile(String title, String meta, {String? articleId}) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(width: 62, height: 62, decoration: BoxDecoration(color: const Color(0xFF283244), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.newspaper_rounded, color: gold, size: 27)),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 7), child: Text(meta, style: const TextStyle(color: muted, fontSize: 9, letterSpacing: .6))),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ArticleDetailScreen(
            title: title,
            meta: meta,
            articleId: articleId ?? title,
          ),
        ),
      ),
    ),
  );

  Widget _giftCard(IconData icon, String title, String subtitle) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.all(15),
      leading: CircleAvatar(radius: 26, backgroundColor: const Color(0xFF302A1D), child: Icon(icon, color: gold)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: muted),
    ),
  );

  Widget _step(String n, String title, String desc) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(radius: 17, backgroundColor: red.withValues(alpha: .18), child: Text(n, style: const TextStyle(color: red, fontWeight: FontWeight.w900, fontSize: 11))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(desc, style: const TextStyle(color: muted, fontSize: 12, height: 1.4)),
      ])),
    ]),
  );

  Widget _pageHeading(String title, String subtitle) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
    const SizedBox(height: 5),
    Text(subtitle, style: const TextStyle(color: muted)),
  ]);

  Widget _note(String text) => Container(
    margin: const EdgeInsets.only(top: 14),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: const Color(0xFF20202A), borderRadius: BorderRadius.circular(13)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.info_outline, color: gold, size: 18),
      const SizedBox(width: 9),
      Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFBDC5D1), fontSize: 11, height: 1.45))),
    ]),
  );

  void _startQuiz() async {
    try {
      if (!await AppwriteService.instance.hasSession()) {
        await AppwriteService.instance.signInWithGoogle();
      }
      if (!await AppwriteService.instance.hasSession()) return;
    } catch (error) {
      if (mounted) _message('Google sign-in is required: $error');
      return;
    }
    if (!mounted) return;
    if (!ageConfirmed) {
      final eligible = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => const AgeVerificationScreen(),
        ),
      );
      if (eligible != true) return;
      if (!mounted) return;
      setState(() => ageConfirmed = true);
    }
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuizPage()),
    );
  }

  void _profile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: panel,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Sign in to sync your quiz attempts and rewards.', style: TextStyle(color: muted)),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: AppSignInButton()),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  void _leaderboard() {
    showModalBottomSheet(
      context: context,
      backgroundColor: panel,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Top performers', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          for (final item in [('1', 'CricketFan', '9/10'), ('2', 'CoverDrive', '8/10'), ('3', 'SpinMaster', '8/10')])
            ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFF302A1D), child: Text(item.$1, style: const TextStyle(color: gold))), title: Text(item.$2), trailing: Text(item.$3, style: const TextStyle(fontWeight: FontWeight.w900))),
          const Text('Demo leaderboard — official rankings are calculated server-side.', style: TextStyle(color: muted, fontSize: 11)),
        ]),
      ),
    );
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int? selected;
  int score = 0;
  bool finished = false;
  bool submitting = false;
  String? officialMessage;
  final List<int> answers = [];

  final questions = const [
    ('Which country won the first men’s Cricket World Cup in 1975?', ['India', 'West Indies', 'Australia', 'England'], 1),
    ('How many balls are there in a standard over?', ['4', '5', '6', '8'], 2),
    ('What is the highest individual score in men’s ODI cricket?', ['264', '237', '200', '219'], 0),
    ('Which Indian cricketer is known as the “Hitman”?', ['Virat Kohli', 'MS Dhoni', 'Rohit Sharma', 'KL Rahul'], 2),
    ('How many players are on the fielding side?', ['9', '10', '11', '12'], 2),
  ];

  Future<void> next() async {
    if (selected == null || submitting) return;
    answers.add(selected!);
    if (selected == questions[index].$3) score++;
    if (index == questions.length - 1) {
      setState(() => submitting = true);
      try {
        officialMessage = await CricketRepository.instance.submitQuizAttempt(
          quizId: 'daily',
          answers: answers,
        );
      } catch (error) {
        officialMessage = 'Practice result only. Official submission is unavailable: $error';
      }
      if (!mounted) return;
      setState(() {
        finished = true;
        submitting = false;
      });
    } else {
      setState(() {
        index++;
        selected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DAILY QUIZ'), actions: [const Padding(padding: EdgeInsets.only(right: 18), child: Center(child: Text('FREE ENTRY', style: TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.w900))))]),
      body: finished ? _result() : _question(),
    );
  }

  Widget _question() {
    final q = questions[index];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text('QUESTION ${index + 1} OF ${questions.length}', style: const TextStyle(color: muted, fontWeight: FontWeight.w800, letterSpacing: 1)), const Spacer(), Text('${((index + 1) / questions.length * 100).round()}%', style: const TextStyle(color: gold, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: (index + 1) / questions.length, minHeight: 6, color: red, backgroundColor: panel)),
        const SizedBox(height: 30),
        Text(q.$1, style: const TextStyle(fontSize: 25, height: 1.25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 22),
        for (var i = 0; i < q.$2.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: InkWell(
              onTap: () => setState(() => selected = i),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(color: selected == i ? red.withValues(alpha: .16) : panel, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected == i ? red : const Color(0xFF252D3A), width: selected == i ? 1.5 : 1)),
                child: Row(children: [
                  CircleAvatar(radius: 14, backgroundColor: selected == i ? red : const Color(0xFF293241), child: Text(String.fromCharCode(65 + i), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900))),
                  const SizedBox(width: 13),
                  Expanded(child: Text(q.$2[i], style: const TextStyle(fontWeight: FontWeight.w700))),
                  if (selected == i) const Icon(Icons.check_circle, color: red),
                ]),
              ),
            ),
          ),
        const Spacer(),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: selected == null || submitting ? null : next,
          style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 16)),
          child: submitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(index == questions.length - 1 ? 'Submit answers' : 'Next question'),
        )),
        const SizedBox(height: 10),
        const Center(child: Text('One attempt per quiz • Do your best!', style: TextStyle(color: muted, fontSize: 11))),
      ]),
    );
  }

  Widget _result() => Center(
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.emoji_events_rounded, color: gold, size: 76),
        const SizedBox(height: 18),
        const Text('Quiz completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Text('$score / ${questions.length}', style: const TextStyle(fontSize: 48, color: gold, fontWeight: FontWeight.w900)),
        const Text('Your practice score', style: TextStyle(color: muted)),
        const SizedBox(height: 18),
        Text(officialMessage ?? 'Practice result only. Configure the trusted Appwrite quiz Function to validate and store official scores.', textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(backgroundColor: red), child: const Text('Back to home'))),
      ]),
    ),
  );
}
