import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../theme/app_theme.dart';
import '../chat/chat_screen.dart';
import '../settings/settings_screen.dart';
import 'modules/email_manager_screen.dart';
import 'modules/expense_tracker_screen.dart';
import 'modules/planner_screen.dart';
import 'modules/job_bot_screen.dart';
import 'modules/meeting_intelligence_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final userEmail = auth.user?.email ?? '';
    final userId = auth.user?.id;

    const pages = <Widget>[
      ChatScreen(),
      EmailManagerScreen(),
      ExpenseTrackerScreen(),
      PlannerScreen(),
      JobBotScreen(),
      MeetingIntelligenceScreen(),
    ];

    const titles = [
      'Chat',
      'AI Email Manager',
      'Expense Tracker',
      'Calendar & Tasks',
      'Job Application Bot',
      'Meeting Intelligence',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        final body = IndexedStack(index: _idx, children: pages);

        return Scaffold(
          backgroundColor: AriaColors.background,
          appBar: AppBar(
            title: Text(titles[_idx]),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AriaColors.divider),
            ),
            actions: [
              if (userEmail.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AriaColors.primarySurface,
                        borderRadius: BorderRadius.circular(Rad.full),
                        border: Border.all(color: AriaColors.primaryBorder),
                      ),
                      child: Text(
                        userEmail,
                        overflow: TextOverflow.ellipsis,
                        style: AriaText.labelSmall.copyWith(
                          color: AriaColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: isWide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _idx,
                      onDestinationSelected: (v) => setState(() => _idx = v),
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: AriaColors.surface,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.chat_bubble_rounded),
                          label: Text('Chat'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.email_rounded),
                          label: Text('Email'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.payments_rounded),
                          label: Text('Expenses'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.event_available_rounded),
                          label: Text('Planner'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.work_rounded),
                          label: Text('Jobs'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.mic_rounded),
                          label: Text('Meetings'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: body),
                  ],
                )
              : body,
          floatingActionButton: _buildFab(context, userId),
          bottomNavigationBar: isWide
              ? null
              : BottomNavigationBar(
                  currentIndex: _idx,
                  onTap: (v) => setState(() => _idx = v),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AriaColors.primary,
                  unselectedItemColor: AriaColors.textHint,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_rounded),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.email_rounded),
                      label: 'Email',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.payments_rounded),
                      label: 'Expenses',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event_available_rounded),
                      label: 'Planner',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.work_rounded),
                      label: 'Jobs',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.mic_rounded),
                      label: 'Meetings',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget? _buildFab(BuildContext context, int? userId) {
    if (userId == null) return null;

    final db = ref.read(appDatabaseProvider);
    switch (_idx) {
      case 2: // expenses
        return FloatingActionButton(
          onPressed: () => showAddExpenseSheet(context, ref, db, userId),
          backgroundColor: AriaColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        );
      case 3: // planner
        return FloatingActionButton(
          onPressed: () => showAddTaskSheet(context, db, userId),
          backgroundColor: AriaColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        );
      case 4: // jobs
        return FloatingActionButton(
          onPressed: () => showAddJobSheet(context, db, userId),
          backgroundColor: AriaColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        );
      case 5: // meetings
        return FloatingActionButton(
          onPressed: () => showAddMeetingSheet(context, db, userId),
          backgroundColor: AriaColors.primary,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        );
      default:
        return null;
    }
  }
}

