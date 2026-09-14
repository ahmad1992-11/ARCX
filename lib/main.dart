import 'package:flutter/material.dart';

import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.instance.initialize();

  runApp(const ARCXApp());
}

/* ============================================================
   ARCX
   Architecture & Engineering Intelligence
   Foundation v0.2
   ============================================================ */

class ARCXApp extends StatelessWidget {
  const ARCXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARCX',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF4F8CFF),
        scaffoldBackgroundColor: const Color(0xFF0B0D11),
        cardTheme: CardThemeData(
          color: const Color(0xFF15181E),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF15181E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF4F8CFF),
            ),
          ),
        ),
      ),
      home: const ARCXRoot(),
    );
  }
}

/* ============================================================
   DATA MODELS
   ============================================================ */

class Project {
  final String id;
  String name;
  String location;
  String category;
  String status;
  final DateTime createdAt;
  final List<Measurement> measurements;
  final List<NoteItem> notes;

  Project({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    this.status = 'Active',
    DateTime? createdAt,
    List<Measurement>? measurements,
    List<NoteItem>? notes,
  })  : createdAt = createdAt ?? DateTime.now(),
        measurements = measurements ?? [],
        notes = notes ?? [];
}

class Measurement {
  final String type;
  final double value;
  final String unit;
  final DateTime date;

  Measurement({
    required this.type,
    required this.value,
    required this.unit,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class NoteItem {
  final String title;
  final String text;
  final DateTime date;

  NoteItem({
    required this.title,
    required this.text,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class FinanceTransaction {
  final String title;
  final double amount;
  final bool income;
  final bool projectRelated;
  final DateTime date;

  FinanceTransaction({
    required this.title,
    required this.amount,
    required this.income,
    required this.projectRelated,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class MaterialItem {
  final String name;
  final String category;
  final String unit;
  double price;

  MaterialItem({
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
  });
}

/* ============================================================
   ROOT
   ============================================================ */

class ARCXRoot extends StatefulWidget {
  const ARCXRoot({super.key});

  @override
  State<ARCXRoot> createState() => _ARCXRootState();
}

class _ARCXRootState extends State<ARCXRoot> {
  int tab = 0;

  final List<Project> projects = [
    Project(
      id: 'ARCX-001',
      name: 'Demo Architecture Project',
      location: 'Tehran',
      category: 'Architecture',
    ),
  ];

  final List<Measurement> globalMeasurements = [];

  final List<FinanceTransaction> transactions = [];

  final List<MaterialItem> materials = [
    MaterialItem(
      name: 'Concrete',
      category: 'Structure',
      unit: 'm³',
      price: 0,
    ),
    MaterialItem(
      name: 'Steel',
      category: 'Structure',
      unit: 'kg',
      price: 0,
    ),
    MaterialItem(
      name: 'MDF',
      category: 'Interior',
      unit: 'sheet',
      price: 0,
    ),
  ];

  void addProject(Project project) {
    setState(() {
      projects.add(project);
    });
  }

  void deleteProject(Project project) {
    setState(() {
      projects.remove(project);
    });
  }

  void addMeasurement(Measurement measurement) {
    setState(() {
      globalMeasurements.add(measurement);
    });
  }

  void addTransaction(FinanceTransaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        projects: projects,
        measurements: globalMeasurements,
        onModuleTap: openModule,
      ),
      ProjectsPage(
        projects: projects,
        onCreate: addProject,
        onDelete: deleteProject,
      ),
      FieldToolsPage(
        measurements: globalMeasurements,
        onSave: addMeasurement,
      ),
      const SettingsPage(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: pages[tab],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) {
            setState(() {
              tab = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'خانه',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'پروژه‌ها',
            ),
            NavigationDestination(
              icon: Icon(Icons.straighten_outlined),
              selectedIcon: Icon(Icons.straighten),
              label: 'ابزار',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'تنظیمات',
            ),
          ],
        ),
      ),
    );
  }

  void openModule(String module) {
    Widget? page;

    switch (module) {
      case 'Field Tools':
        page = FieldToolsPage(
          measurements: globalMeasurements,
          onSave: addMeasurement,
        );
        break;

      case 'Projects':
        page = ProjectsPage(
          projects: projects,
          onCreate: addProject,
          onDelete: deleteProject,
        );
        break;

      case 'Calculators':
        page = const CalculatorsPage();
        break;

      case 'Plans':
        page = const PlansPage();
        break;

      case 'Materials':
        page = MaterialsPage(materials: materials);
        break;

      case 'Documentation':
        page = DocumentationPage(projects: projects);
        break;

      case 'Finance':
        page = FinancePage(
          transactions: transactions,
          onAdd: addTransaction,
        );
        break;

      case 'Intelligence':
        page = const IntelligencePage();
        break;
    }

    if (page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Directionality(
            textDirection: TextDirection.rtl,
            child: page!,
          ),
        ),
      );
    }
  }
}

/* ============================================================
   DASHBOARD
   ============================================================ */

class DashboardPage extends StatelessWidget {
  final List<Project> projects;
  final List<Measurement> measurements;
  final ValueChanged<String> onModuleTap;

  const DashboardPage({
    super.key,
    required this.projects,
    required this.measurements,
    required this.onModuleTap,
  });

  static const List<_DashboardModule> modules = [
    _DashboardModule(
      title: 'Field Tools',
      subtitle: 'ابزارهای میدانی',
      icon: Icons.straighten,
    ),
    _DashboardModule(
      title: 'Projects',
      subtitle: 'مدیریت پروژه',
      icon: Icons.account_tree_outlined,
    ),
    _DashboardModule(
      title: 'Calculators',
      subtitle: 'محاسبات',
      icon: Icons.calculate_outlined,
    ),
    _DashboardModule(
      title: 'Plans',
      subtitle: 'طراحی پلان',
      icon: Icons.architecture_outlined,
    ),
    _DashboardModule(
      title: 'Materials',
      subtitle: 'مصالح',
      icon: Icons.layers_outlined,
    ),
    _DashboardModule(
      title: 'Documentation',
      subtitle: 'مستندات',
      icon: Icons.description_outlined,
    ),
    _DashboardModule(
      title: 'Finance',
      subtitle: 'مالی',
      icon: Icons.account_balance_wallet_outlined,
    ),
    _DashboardModule(
      title: 'Intelligence',
      subtitle: 'هوش معماری',
      icon: Icons.psychology_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ARCX',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Architecture & Engineering Intelligence',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ModuleSearchDelegate(
                        modules: modules,
                        onSelected: onModuleTap,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _ProjectOverview(
              projects: projects,
              measurements: measurements,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final module = modules[index];

                return _ModuleCard(
                  title: module.title,
                  subtitle: module.subtitle,
                  icon: module.icon,
                  onTap: () =>
                      onModuleTap(module.title),
                );
              },
              childCount: modules.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }
}

class _DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;

  const _DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _ProjectOverview extends StatelessWidget {
  final List<Project> projects;
  final List<Measurement> measurements;

  const _ProjectOverview({
    required this.projects,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.architecture,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Core',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'هسته مرکزی ARCX',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const _VersionBadge(),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                _Stat(
                  title: 'پروژه',
                  value: projects.length.toString(),
                ),
                _Stat(
                  title: 'اندازه‌گیری',
                  value:
                      measurements.length.toString(),
                ),
                const _Stat(
                  title: 'ماژول',
                  value: '8',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              value: .15,
              minHeight: 7,
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ARCX foundation v0.2',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'v0.2',
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String title;
  final String value;

  const _Stat({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   PROJECTS
   ============================================================ */

class ProjectsPage extends StatelessWidget {
  final List<Project> projects;
  final ValueChanged<Project> onCreate;
  final ValueChanged<Project> onDelete;

  const ProjectsPage({
    super.key,
    required this.projects,
    required this.onCreate,
    required this.onDelete,
  });

  void _create(BuildContext context) {
    final name = TextEditingController();
    final location = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ساخت پروژه جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'نام پروژه',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: location,
              decoration: const InputDecoration(
                labelText: 'موقعیت پروژه',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty) return;

              onCreate(
                Project(
                  id: 'ARCX-${DateTime.now().millisecondsSinceEpoch}',
                  name: name.text.trim(),
                  location: location.text.trim(),
                  category: 'Architecture',
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('ساخت پروژه'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پروژه‌ها',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add),
        label: const Text('پروژه جدید'),
      ),
      body: projects.isEmpty
          ? const Center(
              child: Text(
                'هیچ پروژه‌ای وجود ندارد.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final project = projects[index];

                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(12),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.architecture,
                      ),
                    ),
                    title: Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      '${project.location} • ${project.category}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          onDelete(project);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('حذف پروژه'),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProjectDetailPage(
                            project: project,
                          ),
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

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailPage> createState() =>
      _ProjectDetailPageState();
}

class _ProjectDetailPageState
    extends State<ProjectDetailPage> {
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void addNote() {
    if (noteController.text.trim().isEmpty) return;

    setState(() {
      widget.project.notes.add(
        NoteItem(
          title: 'یادداشت پروژه',
          text: noteController.text.trim(),
        ),
      );
    });

    noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            title: 'اطلاعات پروژه',
            children: [
              _InfoRow(
                label: 'شناسه',
                value: project.id,
              ),
              _InfoRow(
                label: 'موقعیت',
                value: project.location,
              ),
              _InfoRow(
                label: 'نوع',
                value: project.category,
              ),
              _InfoRow(
                label: 'وضعیت',
                value: project.status,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoCard(
            title: 'اندازه‌گیری‌ها',
            children: [
              if (project.measurements.isEmpty)
                const Text(
                  'هنوز اندازه‌گیری‌ای ثبت نشده.',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                )
              else
                ...project.measurements.map(
                  (m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.straighten,
                    ),
                    title: Text(m.type),
                    trailing: Text(
                      '${m.value} ${m.unit}',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoCard(
            title: 'یادداشت‌ها',
            children: [
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration:
                    const InputDecoration(
                  hintText:
                      'یادداشت پروژه را وارد کنید...',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: addNote,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'ثبت یادداشت',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...project.notes.reversed.map(
                (note) => Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.text),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   FIELD TOOLS
   ============================================================ */

class FieldToolsPage extends StatefulWidget {
  final List<Measurement> measurements;
  final ValueChanged<Measurement> onSave;

  const FieldToolsPage({
    super.key,
    required this.measurements,
    required this.onSave,
  });

  @override
  State<FieldToolsPage> createState() =>
      _FieldToolsPageState();
}

class _FieldToolsPageState
    extends State<FieldToolsPage> {
  final distance = TextEditingController();
  final angle = TextEditingController();
  final length = TextEditingController();
  final width = TextEditingController();

  String distanceUnit = 'm';

  @override
  void dispose() {
    distance.dispose();
    angle.dispose();
    length.dispose();
    width.dispose();
    super.dispose();
  }

  void saveDistance() {
    final value =
        double.tryParse(distance.text);

    if (value == null) {
      _message('مقدار فاصله صحیح نیست.');
      return;
    }

    widget.onSave(
      Measurement(
        type: 'Distance',
        value: value,
        unit: distanceUnit,
      ),
    );

    distance.clear();
    _message('اندازه‌گیری ذخیره شد.');
  }

  void saveAngle() {
    final value =
        double.tryParse(angle.text);

    if (value == null) {
      _message('زاویه صحیح نیست.');
      return;
    }

    widget.onSave(
      Measurement(
        type: 'Angle',
        value: value,
        unit: '°',
      ),
    );

    angle.clear();
    _message('زاویه ذخیره شد.');
  }

  void calculateArea() {
    final l = double.tryParse(length.text);
    final w = double.tryParse(width.text);

    if (l == null || w == null) {
      _message('طول و عرض را وارد کنید.');
      return;
    }

    final result = l * w;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('نتیجه محاسبه'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('مساحت'),
            const SizedBox(height: 10),
            Text(
              '${result.toStringAsFixed(2)} m²',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ابزارهای میدانی',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Field Tools',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'برداشت و اندازه‌گیری در محل پروژه',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 20),
          _ToolCard(
            icon: Icons.straighten,
            title: 'Distance',
            subtitle: 'اندازه‌گیری فاصله',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: distance,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      labelText: 'مقدار',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: distanceUnit,
                  items: const [
                    DropdownMenuItem(
                      value: 'mm',
                      child: Text('mm'),
                    ),
                    DropdownMenuItem(
                      value: 'cm',
                      child: Text('cm'),
                    ),
                    DropdownMenuItem(
                      value: 'm',
                      child: Text('m'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        distanceUnit = v;
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: saveDistance,
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ToolCard(
            icon: Icons.change_history,
            title: 'Angle',
            subtitle: 'زاویه‌یاب',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: angle,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      labelText: 'درجه',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: saveAngle,
                  child: const Text('ثبت'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ToolCard(
            icon: Icons.crop_square,
            title: 'Area',
            subtitle: 'محاسبه مساحت',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: length,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText: 'طول (m)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: width,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration:
                            const InputDecoration(
                          labelText: 'عرض (m)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: calculateArea,
                    child: const Text(
                      'محاسبه',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _ToolCard(
            icon: Icons.water_drop_outlined,
            title: 'Bubble Level',
            subtitle: 'تراز حباب با سنسور دستگاه',
          ),
          const SizedBox(height: 12),
          const _ToolCard(
            icon: Icons.screen_rotation_outlined,
            title: 'Inclinometer',
            subtitle: 'شیب‌سنج',
          ),
          const SizedBox(height: 12),
          const _ToolCard(
            icon: Icons.camera_alt_outlined,
            title: 'Camera Measure',
            subtitle: 'اندازه‌گیری با دوربین',
          ),
          const SizedBox(height: 12),
          const _ToolCard(
            icon: Icons.architecture_outlined,
            title: 'Plan Sketch',
            subtitle: 'ترسیم سریع پلان',
          ),
          if (widget.measurements.isNotEmpty) ...[
            const SizedBox(height: 25),
            const Text(
              'آخرین اندازه‌گیری‌ها',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.measurements.reversed
                .take(10)
                .map(
                  (m) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.analytics_outlined,
                      ),
                      title: Text(m.type),
                      trailing: Text(
                        '${m.value} ${m.unit}',
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (child != null) ...[
              const SizedBox(height: 15),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   CALCULATORS
   ============================================================ */

class CalculatorsPage extends StatelessWidget {
  const CalculatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محاسبات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Calculators',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          _CalculatorTile(
            icon: Icons.square_foot,
            title: 'مساحت',
            subtitle: 'مستطیل، مثلث، دایره و فضاها',
          ),
          _CalculatorTile(
            icon: Icons.view_in_ar_outlined,
            title: 'حجم',
            subtitle: 'محاسبه حجم عناصر هندسی',
          ),
          _CalculatorTile(
            icon: Icons.percent,
            title: 'درصد',
            subtitle: 'درصد و نسبت',
          ),
          _CalculatorTile(
            icon: Icons.swap_horiz,
            title: 'تبدیل واحد',
            subtitle: 'طول، مساحت، حجم و وزن',
          ),
          _CalculatorTile(
            icon: Icons.architecture,
            title: 'محاسبات معماری',
            subtitle: 'سطح اشغال، تراکم و زیربنا',
          ),
          _CalculatorTile(
            icon: Icons.construction,
            title: 'مصالح',
            subtitle: 'برآورد اولیه مصرف مصالح',
          ),
        ],
      ),
    );
  }
}

class _CalculatorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CalculatorTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.all(12),
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(subtitle),
        trailing:
            const Icon(Icons.chevron_left),
      ),
    );
  }
}

/* ============================================================
   PLANS
   ============================================================ */

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طراحی پلان'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Plan Studio',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'هسته طراحی پلان هوشمند ARCX',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 22),
          _CalculatorTile(
            icon: Icons.grid_4x4,
            title: 'Grid',
            subtitle: 'شبکه ترسیم',
          ),
          _CalculatorTile(
            icon: Icons.crop_square,
            title: 'Walls',
            subtitle: 'ترسیم دیوارها',
          ),
          _CalculatorTile(
            icon: Icons.door_front_door_outlined,
            title: 'Doors',
            subtitle: 'درها و بازشوها',
          ),
          _CalculatorTile(
            icon: Icons.window_outlined,
            title: 'Windows',
            subtitle: 'پنجره‌ها',
          ),
          _CalculatorTile(
            icon: Icons.straighten,
            title: 'Dimensions',
            subtitle: 'اندازه‌گذاری',
          ),
          _CalculatorTile(
            icon: Icons.edit,
            title: 'Sketch',
            subtitle: 'ترسیم آزاد',
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   MATERIALS
   ============================================================ */

class MaterialsPage extends StatelessWidget {
  final List<MaterialItem> materials;

  const MaterialsPage({
    super.key,
    required this.materials,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مصالح و متریال'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Materials',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'بانک مصالح و اطلاعات متریال',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 20),
          ...materials.map(
            (material) => Card(
              margin:
                  const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.layers_outlined,
                ),
                title: Text(
                  material.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  '${material.category} • ${material.unit}',
                ),
                trailing: Text(
                  material.price == 0
                      ? '—'
                      : material.price
                          .toStringAsFixed(0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   DOCUMENTATION
   ============================================================ */

class DocumentationPage extends StatelessWidget {
  final List<Project> projects;

  const DocumentationPage({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مستندسازی'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Documentation',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          _CalculatorTile(
            icon: Icons.photo_library_outlined,
            title: 'Site Photos',
            subtitle: 'تصاویر کارگاه و پروژه',
          ),
          _CalculatorTile(
            icon: Icons.description_outlined,
            title: 'Documents',
            subtitle: 'اسناد پروژه',
          ),
          _CalculatorTile(
            icon: Icons.note_alt_outlined,
            title: 'Notes',
            subtitle: 'یادداشت‌های پروژه',
          ),
          _CalculatorTile(
            icon: Icons.checklist,
            title: 'Checklists',
            subtitle: 'چک‌لیست‌های اجرایی',
          ),
          const SizedBox(height: 20),
          Text(
            'پروژه‌های قابل مستندسازی: ${projects.length}',
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   FINANCE
   ============================================================ */

class FinancePage extends StatefulWidget {
  final List<FinanceTransaction> transactions;
  final ValueChanged<FinanceTransaction> onAdd;

  const FinancePage({
    super.key,
    required this.transactions,
    required this.onAdd,
  });

  @override
  State<FinancePage> createState() =>
      _FinancePageState();
}

class _FinancePageState
    extends State<FinancePage> {
  void addTransaction() {
    final title = TextEditingController();
    final amount = TextEditingController();

    bool income = true;
    bool project = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocalState) {
          return AlertDialog(
            title: const Text('تراکنش جدید'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration:
                      const InputDecoration(
                    labelText: 'عنوان',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(
                    labelText: 'مبلغ',
                  ),
                ),
                SwitchListTile(
                  title: const Text('درآمد'),
                  value: income,
                  onChanged: (v) {
                    setLocalState(() {
                      income = v;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('پروژه‌ای'),
                  value: project,
                  onChanged: (v) {
                    setLocalState(() {
                      project = v;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text('انصراف'),
              ),
              FilledButton(
                onPressed: () {
                  final value =
                      double.tryParse(
                    amount.text,
                  );

                  if (value == null ||
                      title.text.trim().isEmpty) {
                    return;
                  }

                  widget.onAdd(
                    FinanceTransaction(
                      title: title.text.trim(),
                      amount: value,
                      income: income,
                      projectRelated: project,
                    ),
                  );

                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('ثبت'),
              ),
            ],
          );
        },
      ),
    );
  }

  double total({
    required bool project,
    required bool income,
  }) {
    return widget.transactions
        .where(
          (t) =>
              t.projectRelated == project &&
              t.income == income,
        )
        .fold(
          0,
          (sum, item) => sum + item.amount,
        );
  }

  @override
  Widget build(BuildContext context) {
    final projectIncome =
        total(project: true, income: true);

    final projectExpense =
        total(project: true, income: false);

    final personalIncome =
        total(project: false, income: true);

    final personalExpense =
        total(project: false, income: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مالی'),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addTransaction,
        icon: const Icon(Icons.add),
        label: const Text('تراکنش'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Finance',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'مالی پروژه و شخصی از هم جدا هستند.',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 20),
          _FinanceSummary(
            title: 'مالی پروژه',
            income: projectIncome,
            expense: projectExpense,
          ),
          const SizedBox(height: 12),
          _FinanceSummary(
            title: 'مالی شخصی',
            income: personalIncome,
            expense: personalExpense,
          ),
          const SizedBox(height: 20),
          if (widget.transactions.isNotEmpty)
            ...widget.transactions.reversed.map(
              (transaction) => Card(
                margin:
                    const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    transaction.income
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  title: Text(transaction.title),
                  subtitle: Text(
                    transaction.projectRelated
                        ? 'پروژه‌ای'
                        : 'شخصی',
                  ),
                  trailing: Text(
                    transaction.amount
                        .toStringAsFixed(0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FinanceSummary extends StatelessWidget {
  final String title;
  final double income;
  final double expense;

  const _FinanceSummary({
    required this.title,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'مانده: ${balance.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'درآمد: ${income.toStringAsFixed(0)}',
                  ),
                ),
                Expanded(
                  child: Text(
                    'هزینه: ${expense.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   INTELLIGENCE
   ============================================================ */

class IntelligencePage extends StatelessWidget {
  const IntelligencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('هوش معماری'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'ARCX Intelligence',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لایه هوشمند سیستم',
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 22),
          _CalculatorTile(
            icon: Icons.auto_awesome,
            title: 'AI Assistant',
            subtitle: 'دستیار معماری و مهندسی',
          ),
          _CalculatorTile(
            icon: Icons.analytics_outlined,
            title: 'Project Analysis',
            subtitle: 'تحلیل پروژه',
          ),
          _CalculatorTile(
            icon: Icons.lightbulb_outline,
            title: 'Design Suggestions',
            subtitle: 'پیشنهادهای طراحی',
          ),
          _CalculatorTile(
            icon: Icons.warning_amber_outlined,
            title: 'Risk Detection',
            subtitle: 'تشخیص ریسک',
          ),
          _CalculatorTile(
            icon: Icons.auto_graph,
            title: 'Optimization',
            subtitle: 'بهینه‌سازی',
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SETTINGS
   ============================================================ */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('زبان'),
            subtitle: Text('فارسی / English'),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text('ظاهر'),
            subtitle: Text('Dark Mode'),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Storage'),
            subtitle: Text(
              'هسته ذخیره‌سازی محلی — مرحله بعد',
            ),
          ),
          ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Cloud Sync'),
            subtitle: Text(
              'همگام‌سازی ابری — مرحله بعد',
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('ARCX'),
            subtitle: Text(
              'Architecture & Engineering Intelligence',
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SEARCH
   ============================================================ */

class ModuleSearchDelegate
    extends SearchDelegate<String> {
  final List<_DashboardModule> modules;
  final ValueChanged<String> onSelected;

  ModuleSearchDelegate({
    required this.modules,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    final q = query.toLowerCase();

    final results = modules.where((module) {
      return module.title
              .toLowerCase()
              .contains(q) ||
          module.subtitle.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final module = results[index];

        return ListTile(
          leading: Icon(module.icon),
          title: Text(module.title),
          subtitle: Text(module.subtitle),
          onTap: () {
            close(context, module.title);
            onSelected(module.title);
          },
        );
      },
    );
  }
}

/* ============================================================
   INFO COMPONENTS
   ============================================================ */

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}