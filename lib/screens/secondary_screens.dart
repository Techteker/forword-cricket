import 'package:flutter/material.dart';

import '../app.dart';
import '../services/appwrite_service.dart';
import '../services/cricket_repository.dart';

class MoreFeaturesScreen extends StatelessWidget {
  const MoreFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = <(IconData, String, String, Widget)>[
      (Icons.search_rounded, 'Search', 'Find cricket news and topics', const SearchFeatureScreen()),
      (Icons.bookmark_outline_rounded, 'Saved articles', 'Your bookmarked cricket reads', const SavedArticlesScreen()),
      (Icons.notifications_active_outlined, 'Notifications', 'Updates about quizzes and gifts', const NotificationsScreen()),
      (Icons.leaderboard_rounded, 'Leaderboard', 'View quiz rankings', const LeaderboardScreen()),
      (Icons.history_rounded, 'Quiz history', 'Your previous attempts', const QuizHistoryScreen()),
      (Icons.person_outline_rounded, 'My profile', 'Account and eligibility', const ProfileScreen()),
      (Icons.verified_user_outlined, 'Age verification', 'Verify 16+ eligibility securely', const AgeVerificationScreen()),
      (Icons.settings_outlined, 'Settings', 'App preferences', const SettingsScreen()),
      (Icons.rule_rounded, 'Contest rules', 'Eligibility and reward terms', const ContestRulesScreen()),
      (Icons.help_outline_rounded, 'Help & support', 'Get help with your account', const HelpScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('EXPLORE MORE')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: red.withValues(alpha: .15),
                child: Icon(feature.$1, color: gold),
              ),
              title: Text(feature.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(feature.$3, style: const TextStyle(color: muted)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => feature.$4),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchFeatureScreen extends StatefulWidget {
  const SearchFeatureScreen({super.key});

  @override
  State<SearchFeatureScreen> createState() => _SearchFeatureScreenState();
}

class _SearchFeatureScreenState extends State<SearchFeatureScreen> {
  final controller = TextEditingController();
  String category = 'All';
  final categories = const ['All', 'India', 'IPL', 'International', 'Records'];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SEARCH CRICKET')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search teams, players, news...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: panel,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: categories.map((item) => ChoiceChip(
              label: Text(item),
              selected: category == item,
              onSelected: (_) => setState(() => category = item),
            )).toList(),
          ),
          const SizedBox(height: 24),
          const Text('TRENDING SEARCHES', style: TextStyle(color: gold, fontWeight: FontWeight.w900, letterSpacing: 1)),
          const SizedBox(height: 10),
          for (final term in ['Team India', 'Indian Premier League', 'Cricket World Cup', 'Batting records'])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.trending_up, color: muted),
              title: Text(term),
              onTap: () => setState(() => controller.text = term),
            ),
          if (controller.text.isNotEmpty)
            Text('Search for “${controller.text}” will include connected news and match data once Appwrite tables are configured.', style: const TextStyle(color: muted)),
        ],
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.title, required this.meta, required this.articleId});

  final String title;
  final String meta;
  final String articleId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('NEWS ARTICLE')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(colors: [Color(0xFF641525), Color(0xFF171923)]),
          ),
          child: const Icon(Icons.sports_cricket_rounded, size: 72, color: gold),
        ),
        const SizedBox(height: 20),
        Text(meta, style: const TextStyle(color: gold, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 27, height: 1.2, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        const Text('Article content will be loaded from the verified news feed. This preview is a placeholder until the RSS ingestion and article detail fields are connected.', style: TextStyle(color: muted, height: 1.6)),
        const SizedBox(height: 20),
        const Text('Forword Cricket publishes short cricket reads. Always check the original publisher for full coverage and updates.', style: TextStyle(color: muted, fontSize: 12, height: 1.5)),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              try {
                await CricketRepository.instance.saveArticle(
                  articleId: articleId,
                  title: title,
                  sourceName: meta,
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Article saved to your library.')),
                );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
              }
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Save article'),
          ),
        ),
      ],
    ),
  );
}

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SAVED ARTICLES')),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: CricketRepository.instance.getSavedArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(snapshot.error.toString(), textAlign: TextAlign.center),
          ));
        }
        final rows = snapshot.data ?? const <Map<String, dynamic>>[];
        if (rows.isEmpty) {
          return const _EmptyState(
            icon: Icons.bookmark_border_rounded,
            title: 'No saved articles yet',
            message: 'Open a cricket news story and tap Save article to keep it here.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            final title = (row['title'] ?? 'Cricket article').toString();
            final meta = (row['sourceName'] ?? 'SAVED ARTICLE').toString();
            final articleId = (row['articleId'] ?? title).toString();
            return Card(
              child: ListTile(
                leading: const Icon(Icons.bookmark, color: gold),
                title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(meta, style: const TextStyle(color: muted)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ArticleDetailScreen(
                      title: title,
                      meta: meta,
                      articleId: articleId,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NOTIFICATIONS')),
      body: const _EmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'You are all caught up',
        message: 'Quiz reminders, match alerts and gift updates will appear here after notifications are enabled.',
      ),
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final Future<List<Map<String, dynamic>>> entries =
      CricketRepository.instance.getLeaderboard('daily');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LEADERBOARD')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _EmptyState(icon: Icons.cloud_off, title: 'Could not load rankings', message: snapshot.error.toString());
          }
          final rows = snapshot.data ?? const [];
          if (rows.isEmpty) {
            return const _EmptyState(icon: Icons.emoji_events_outlined, title: 'Rankings coming soon', message: 'Official rankings appear after quiz results are verified by the server.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = rows[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: panel, child: Text('${row['rank'] ?? index + 1}', style: const TextStyle(color: gold, fontWeight: FontWeight.w900))),
                  title: Text('${row['displayName'] ?? 'Player'}'),
                  trailing: Text('${row['score'] ?? 0} pts', style: const TextStyle(fontWeight: FontWeight.w900)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('QUIZ HISTORY')),
    body: const _EmptyState(
      icon: Icons.history_rounded,
      title: 'No attempts yet',
      message: 'Your submitted quizzes and verified scores will be listed here after sign-in and backend setup.',
    ),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('MY PROFILE')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const CircleAvatar(radius: 42, backgroundColor: panel, child: Icon(Icons.person, size: 42, color: gold)),
        const SizedBox(height: 14),
        const Center(child: Text('Welcome to Forword Cricket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
        const SizedBox(height: 6),
        const Center(child: Text('Sign in to sync your progress', style: TextStyle(color: muted))),
        const SizedBox(height: 22),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () async {
            try {
              await AppwriteService.instance.signInWithGoogle();
            } catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
            }
          },
          icon: const Icon(Icons.g_mobiledata, size: 26),
          label: const Text('Continue with Google'),
        )),
        const SizedBox(height: 14),
        const _InfoTile(title: 'Account type', value: 'Google sign-in only'),
        const _InfoTile(title: 'Entry model', value: 'Free entry'),
        const _InfoTile(title: 'Rewards', value: 'Physical gifts only'),
      ],
    ),
  );
}

class AgeVerificationScreen extends StatefulWidget {
  const AgeVerificationScreen({super.key});

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  DateTime? dateOfBirth;
  bool checking = false;
  bool verified = false;
  String? message;

  int _age(DateTime birthDate) {
    final today = DateTime.now();
    var years = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 18, today.month, today.day),
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Select your date of birth',
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
        message = null;
        verified = false;
      });
    }
  }

  Future<void> _verify() async {
    final dob = dateOfBirth;
    if (dob == null) {
      setState(() => message = 'Please select your date of birth first.');
      return;
    }
    if (_age(dob) < 16) {
      setState(() => message = 'You must be at least 16 years old to participate.');
      return;
    }
    setState(() {
      checking = true;
      message = null;
    });
    try {
      final accepted = await CricketRepository.instance.verifyAge(dob);
      if (!mounted) return;
      setState(() {
        verified = accepted;
        message = accepted
            ? 'Your 16+ eligibility was confirmed by the server.'
            : 'Eligibility could not be confirmed. Please contact support.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => message = 'Verification service is not configured: $error');
    } finally {
      if (mounted) setState(() => checking = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AGE VERIFICATION')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(Icons.verified_user_outlined, size: 58, color: gold),
        const SizedBox(height: 16),
        const Text('Confirm your eligibility', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Users must be 16 years or older. Your date of birth is sent to a trusted Appwrite Function for verification.', style: TextStyle(color: muted, height: 1.5)),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: checking ? null : _pickDate,
          icon: const Icon(Icons.calendar_month),
          label: Text(dateOfBirth == null
              ? 'Choose date of birth'
              : '${dateOfBirth!.day.toString().padLeft(2, '0')}/${dateOfBirth!.month.toString().padLeft(2, '0')}/${dateOfBirth!.year}'),
        ),
        if (dateOfBirth != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Calculated age: ${_age(dateOfBirth!)} years', style: const TextStyle(color: muted)),
          ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: checking || verified ? null : _verify,
            style: FilledButton.styleFrom(backgroundColor: red, padding: const EdgeInsets.symmetric(vertical: 15)),
            child: checking
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Verify eligibility'),
          ),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(message!, style: TextStyle(color: verified ? Colors.greenAccent : gold)),
          ),
        if (verified)
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(backgroundColor: red),
                child: const Text('Continue to quiz'),
              ),
            ),
          ),
        const SizedBox(height: 16),
        const Text('The server must store only the minimum verification result needed for contest eligibility. Do not expose full birth dates in public profile data.', style: TextStyle(color: muted, fontSize: 12, height: 1.5)),
      ],
    ),
  );
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool matchAlerts = true;
  bool quizReminders = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('SETTINGS')),
    body: ListView(
      children: [
        SwitchListTile(value: matchAlerts, onChanged: (value) => setState(() => matchAlerts = value), title: const Text('Match alerts'), subtitle: const Text('Local preference until push notifications are configured')),
        SwitchListTile(value: quizReminders, onChanged: (value) => setState(() => quizReminders = value), title: const Text('Quiz reminders'), subtitle: const Text('Local preference until push notifications are configured')),
        const Divider(),
        const ListTile(title: Text('App version'), trailing: Text('1.0.0')),
        const ListTile(title: Text('Privacy'), subtitle: Text('Account data is protected by Appwrite permissions when configured.')),
      ],
    ),
  );
}

class ContestRulesScreen extends StatelessWidget {
  const ContestRulesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CONTEST RULES')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: const [
        _RuleTile(number: '01', title: 'Free participation', body: 'There is no entry fee, purchase requirement, deposit or paid participation.'),
        _RuleTile(number: '02', title: 'Age eligibility', body: 'Participation is intended for users aged 16 or older. Age must be verified before an eligible contest entry is accepted.'),
        _RuleTile(number: '03', title: 'Knowledge-based quizzes', body: 'Quizzes test cricket knowledge. They are not betting, wagering, fantasy sports or cash games.'),
        _RuleTile(number: '04', title: 'Physical gifts only', body: 'Eligible winners may receive physical items such as a cap, jersey or cricket bat. No cash prize or withdrawal is offered.'),
        _RuleTile(number: '05', title: 'Fair play', body: 'Duplicate accounts, automated submissions, manipulation and abuse may result in disqualification after review.'),
        _RuleTile(number: '06', title: 'Official terms', body: 'The organiser must publish final contest-specific rules, selection criteria, privacy terms and delivery timelines before launch.'),
      ],
    ),
  );
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('HELP & SUPPORT')),
    body: const _EmptyState(
      icon: Icons.support_agent_rounded,
      title: 'We are here to help',
      message: 'Support contact details will be added before public launch. Please check the contest rules for eligibility and reward information.',
    ),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title),
    trailing: Text(value, style: const TextStyle(color: muted)),
  );
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({required this.number, required this.title, required this.body});

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 17, backgroundColor: red.withValues(alpha: .15), child: Text(number, style: const TextStyle(color: gold, fontSize: 10, fontWeight: FontWeight.w900))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(body, style: const TextStyle(color: muted, height: 1.45)),
        ])),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 54, color: gold),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
        ],
      ),
    ),
  );
}
