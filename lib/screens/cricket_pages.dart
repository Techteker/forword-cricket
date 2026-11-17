import 'package:flutter/material.dart';

import '../app.dart';

/// Reusable, navigable cricket content pages. Sample rows are labelled as
/// editorial placeholders until verified Appwrite/API data is configured.
class CricketHubPage extends StatefulWidget {
  const CricketHubPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.filters = const ['All'],
  });

  final String title;
  final String subtitle;
  final List<String> items;
  final List<String> filters;

  @override
  State<CricketHubPage> createState() => _CricketHubPageState();
}

class _CricketHubPageState extends State<CricketHubPage> {
  final search = TextEditingController();
  String filter = 'All';

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.items.where((item) {
      final q = search.text.trim().toLowerCase();
      final matchesQuery = q.isEmpty || item.toLowerCase().contains(q);
      final matchesFilter = filter == 'All' ||
          item.toLowerCase().contains(filter.toLowerCase());
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(widget.title,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(widget.subtitle, style: const TextStyle(color: muted)),
          const SizedBox(height: 16),
          TextField(
            controller: search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search ${widget.title.toLowerCase()}...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: panel,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.filters.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.filters.map((value) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(value),
                    selected: filter == value,
                    onSelected: (_) => setState(() => filter = value),
                  ),
                )).toList(),
              ),
            ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF20202A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: gold, size: 17),
                SizedBox(width: 8),
                Expanded(child: Text(
                  'Preview content only. Live scores, verified news and official statistics will appear after the data provider and Appwrite collections are connected.',
                  style: TextStyle(color: Color(0xFFBDC5D1), fontSize: 11, height: 1.4),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text('No matching results')),
            )
          else
            for (var i = 0; i < visible.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 9),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: red.withValues(alpha: .14),
                    child: Icon(_iconFor(widget.title), color: gold, size: 20),
                  ),
                  title: Text(visible[i],
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Text('Preview • Data integration pending',
                      style: TextStyle(color: muted, fontSize: 10)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                    builder: (_) => CricketDetailPage(
                      title: visible[i],
                      section: widget.title,
                    ),
                  )),
                ),
              ),
        ],
      ),
    );
  }

  IconData _iconFor(String title) {
    final t = title.toLowerCase();
    if (t.contains('match') || t.contains('score')) return Icons.sports_cricket;
    if (t.contains('news') || t.contains('story')) return Icons.newspaper;
    if (t.contains('player')) return Icons.person;
    if (t.contains('team')) return Icons.groups;
    if (t.contains('quiz')) return Icons.quiz;
    if (t.contains('video')) return Icons.play_circle;
    return Icons.query_stats;
  }
}

class CricketDetailPage extends StatelessWidget {
  const CricketDetailPage({super.key, required this.title, required this.section});
  final String title;
  final String section;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(section.toUpperCase())),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF76202D), Color(0xFF171923)],
            ),
          ),
          child: const Icon(Icons.sports_cricket, color: gold, size: 65),
        ),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(section.toUpperCase(),
            style: const TextStyle(color: gold, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 16),
        const Text(
          'This detail page is ready for connected content. Verified article text, match scorecards, player biographies and statistics must be supplied by the configured data source.',
          style: TextStyle(color: muted, height: 1.6),
        ),
        const SizedBox(height: 18),
        const _DetailRow(label: 'Content status', value: 'Preview'),
        const _DetailRow(label: 'Data source', value: 'Not connected'),
        const _DetailRow(label: 'Last update', value: 'Awaiting provider'),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(label, style: const TextStyle(color: muted, fontSize: 12)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
  );
}

class CricketPageCatalog {
  static const pages = <(String, String, List<String>, List<String>)>[
    ('Live Matches', 'Live match centre and current score updates', ['Live matches will appear here'], ['All']),
    ('Upcoming Matches', 'Fixtures and upcoming cricket schedule', ['India vs Australia', 'England vs South Africa', 'New Zealand vs Pakistan'], ['All', 'India', 'England']),
    ('Recent Matches', 'Recently completed matches', ['Latest international result', 'Latest domestic result'], ['All']),
    ('Match Details & Scorecard', 'Innings, batting, bowling and fall of wickets', ['Full scorecard preview', 'Batting card', 'Bowling card'], ['All']),
    ('Live Commentary', 'Ball-by-ball match commentary', ['Commentary feed preview'], ['All']),
    ('Match Statistics', 'Team and player match statistics', ['Partnerships', 'Wagon wheel', 'Run rate comparison'], ['All']),
    ('Points Table', 'Tournament standings', ['League standings preview', 'Playoff qualification'], ['All']),
    ('Series & Tournaments', 'International and domestic competitions', ['ICC tournaments', 'International series', 'Domestic cricket', 'IPL'], ['All', 'International', 'Domestic', 'IPL']),
    ('Cricket Calendar', 'Browse cricket dates and fixtures', ['Today', 'This week', 'This month'], ['All']),
    ('Breaking News', 'Latest verified cricket headlines', ['Breaking news feed'], ['All']),
    ('India Cricket News', 'News about Team India', ['India team updates', 'India match reports'], ['All']),
    ('International News', 'International cricket coverage', ['Test cricket', 'ODI cricket', 'T20 cricket'], ['All', 'Test', 'ODI', 'T20']),
    ('IPL & Leagues News', 'League news and franchise updates', ['IPL updates', 'WPL updates', 'Other leagues'], ['All', 'IPL', 'WPL']),
    ('Team News', 'Team announcements and analysis', ['India', 'Australia', 'England', 'South Africa'], ['All']),
    ('Player News', 'Player updates, interviews and profiles', ['Player interviews', 'Injury updates', 'Transfers and selections'], ['All']),
    ('Match Reports', 'Post-match reports and reviews', ['Latest match report', 'Series review'], ['All']),
    ('Editorial & Analysis', 'Tactical analysis and opinion', ['Expert analysis', 'Match tactics', 'Team strategy'], ['All']),
    ('Videos & Highlights', 'Cricket video library', ['Match highlights', 'Press conferences', 'Player interviews'], ['All']),
    ('Cricket Explainers', 'Learn cricket rules and tactics', ['Powerplay explained', 'Duckworth-Lewis method', 'Fielding positions', 'Cricket formats'], ['All']),
    ('Trending Stories', 'Popular cricket reads', ['Trending today', 'Most read this week'], ['All']),
    ('Teams Directory', 'Explore international and domestic teams', ['India', 'Australia', 'England', 'New Zealand', 'Pakistan', 'South Africa'], ['All']),
    ('Team Profile', 'Team information and squad pages', ['Team overview', 'Current squad', 'Team records'], ['All']),
    ('Players Directory', 'Explore cricket players', ['Batters', 'Bowlers', 'All-rounders', 'Wicketkeepers'], ['All', 'Batters', 'Bowlers']),
    ('Player Profile', 'Player biography and career details', ['Player overview', 'Career summary', 'Recent performances'], ['All']),
    ('Career Statistics', 'Player career statistics', ['Test career', 'ODI career', 'T20I career', 'Domestic career'], ['All', 'Test', 'ODI', 'T20I']),
    ('Batting Records', 'Notable batting records', ['Most runs', 'Highest scores', 'Most centuries'], ['All']),
    ('Bowling Records', 'Notable bowling records', ['Most wickets', 'Best figures', 'Best averages'], ['All']),
    ('Cricket Rankings', 'Team and player rankings', ['Test rankings', 'ODI rankings', 'T20I rankings'], ['All', 'Test', 'ODI', 'T20I']),
    ('Head-to-Head Comparison', 'Compare teams and players', ['Team comparison', 'Player comparison'], ['All']),
    ('Stadiums & Venues', 'Cricket grounds and venue information', ['International grounds', 'Indian stadiums', 'Venue records'], ['All']),
    ('Cricket Glossary', 'Cricket terms and definitions', ['A to Z cricket terms', 'Rules and laws', 'Umpire signals'], ['All']),
    ('Cricket Records', 'Historic cricket milestones', ['World records', 'India records', 'World Cup records'], ['All']),
    ('Quiz Categories', 'Choose a cricket knowledge topic', ['IPL Quiz', 'World Cup Quiz', 'Player Quiz', 'Cricket History Quiz', 'Rules & Laws Quiz'], ['All', 'IPL', 'World Cup', 'History']),
    ('Quiz Review', 'Review submitted quiz answers', ['Answer review preview', 'Correct answer explanations'], ['All']),
    ('Achievements & Badges', 'Track quiz milestones', ['First quiz', 'Perfect score', 'Quiz streak', 'Knowledge explorer'], ['All']),
    ('My Activity', 'Your reading and quiz activity', ['Reading history', 'Quiz attempts', 'Saved content'], ['All']),
    ('Edit Profile', 'Manage your public profile details', ['Display name', 'Profile photo', 'Account preferences'], ['All']),
    ('Winner Announcements', 'Verified physical gift winner notices', ['Recent winners', 'Gift dispatch updates'], ['All']),
    ('About Forword Cricket', 'About the cricket knowledge platform', ['Our mission', 'Editorial principles', 'Contact information'], ['All']),
    ('Privacy Policy', 'How account and activity data is handled', ['Data collection', 'Data usage', 'Your choices'], ['All']),
    ('Terms & Conditions', 'Platform usage and participation terms', ['Platform terms', 'Quiz participation', 'Physical gift rules'], ['All']),
  ];
}
