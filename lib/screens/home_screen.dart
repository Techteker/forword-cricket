import 'package:flutter/material.dart';
import '../app.dart';
import 'secondary_screens.dart';
import '../services/cricket_repository.dart';

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
            const Text(' CRICKET', style: TextStyle(color: gold, fontWeight: FontWeight.w800, letterSpacing: 1)),
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
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF7E1423), Color(0xFF29121C), Color(0xFF171923)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: red.withValues(alpha: .35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.bolt_rounded, color: gold, size: 17),
                SizedBox(width: 6),
                Text('CRICKET KNOWLEDGE. REAL REWARDS.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              ]),
              const SizedBox(height: 16),
              const Text('Think Cricket.\nPlay the Quiz.', style: TextStyle(fontSize: 31, height: 1.08, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('Test your cricket knowledge. Earn a place on the leaderboard.', style: TextStyle(color: Color(0xFFE0D7DB), height: 1.4)),
              const SizedBox(height: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
                onPressed: () => setState(() => tab = 2),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Play today’s quiz'),
              ),
              const SizedBox(height: 7),
              const Text('FREE ENTRY  •  PHYSICAL GIFTS  •  16+', style: TextStyle(fontSize: 9, letterSpacing: 1, color: gold, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Today at a glance', 'See all', () => setState(() => tab = 1)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _stat('LIVE MATCHES', '02', Icons.sensors_rounded, red)),
          const SizedBox(width: 10),
          Expanded(child: _stat('QUIZ QUESTIONS', '10', Icons.quiz_outlined, gold)),
          const SizedBox(width: 10),
          Expanded(child: _stat('GIFT WINNERS', '03', Icons.emoji_events_outlined, Colors.lightBlueAccent)),
        ]),
        const SizedBox(height: 24),
        _sectionTitle('Featured match', 'All matches', () => setState(() => tab = 1)),
        const SizedBox(height: 12),
        _matchCard('IND', 'AUS', 'India vs Australia', '2nd ODI  •  Today, 2:30 PM', 'UPCOMING'),
        const SizedBox(height: 12),
        _sectionTitle('Your cricket zone', 'Explore', () => setState(() => tab = 3)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _feature(Icons.quiz_rounded, 'Daily Quiz', 'Test your skills', red, () => setState(() => tab = 2))),
          const SizedBox(width: 10),
          Expanded(child: _feature(Icons.emoji_events_rounded, 'Leaderboard', 'See top players', gold, () => _leaderboard())),
        ]),
        const SizedBox(height: 22),
        _sectionTitle('Latest cricket news', 'Read all', () => setState(() => tab = 3)),
        const SizedBox(height: 10),
        _newsTile('India prepare for a high-intensity limited-overs series', 'TEAM INDIA  •  12 MIN AGO'),
        _newsTile('Young stars to watch in the upcoming domestic season', 'CRICKET  •  1 HOUR AGO'),
      ],
    );
  }

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

  Widget _stat(String label, String value, IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFF252D3A))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 19),
      const SizedBox(height: 12),
      Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      Text(label, style: const TextStyle(color: muted, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: .6)),
    ]),
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

  Widget _feature(IconData icon, String title, String sub, Color color, VoidCallback tap) => InkWell(
    onTap: tap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF252D3A))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 25), const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        Text(sub, style: const TextStyle(color: muted, fontSize: 11)),
      ]),
    ),
  );

  Widget _newsTile(String title, String meta) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: Container(width: 62, height: 62, decoration: BoxDecoration(color: const Color(0xFF283244), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.newspaper_rounded, color: gold, size: 27)),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 7), child: Text(meta, style: const TextStyle(color: muted, fontSize: 9, letterSpacing: .6))),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ArticleDetailScreen(title: title, meta: meta),
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
    if (!ageConfirmed) {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Age eligibility'),
          content: const Text('Please confirm that you are 16 years of age or older before entering the quiz.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Not eligible')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('I am 16+')),
          ],
        ),
      );
      if (accepted != true) return;
      setState(() => ageConfirmed = true);
    }
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizPage()));
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

  final questions = const [
    ('Which country won the first men’s Cricket World Cup in 1975?', ['India', 'West Indies', 'Australia', 'England'], 1),
    ('How many balls are there in a standard over?', ['4', '5', '6', '8'], 2),
    ('What is the highest individual score in men’s ODI cricket?', ['264', '237', '200', '219'], 0),
    ('Which Indian cricketer is known as the “Hitman”?', ['Virat Kohli', 'MS Dhoni', 'Rohit Sharma', 'KL Rahul'], 2),
    ('How many players are on the fielding side?', ['9', '10', '11', '12'], 2),
  ];

  void next() {
    if (selected == null) return;
    if (selected == questions[index].$3) score++;
    if (index == questions.length - 1) {
      setState(() => finished = true);
    } else {
      setState(() { index++; selected = null; });
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
          onPressed: selected == null ? null : next,
          style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 16)),
          child: Text(index == questions.length - 1 ? 'Submit answers' : 'Next question'),
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
        const Text('This is a demo quiz. Scores and winners are not submitted or stored yet. Official rankings require backend validation.', textAlign: TextAlign.center, style: TextStyle(color: muted, height: 1.5)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), style: FilledButton.styleFrom(backgroundColor: red), child: const Text('Back to home'))),
      ]),
    ),
  );
}
