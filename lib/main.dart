import 'package:flutter/material.dart';

void main() {
  runApp(const ARCXApp());
}

/* ============================================================
   ARCX
   Architecture & Engineering Intelligence
   Single-file foundation
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
        scaffoldBackgroundColor: const Color(0xFF0D0F13),
        cardTheme: CardThemeData(
          color: const Color(0xFF171A20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF171A20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const ARCXShell(),
    );
  }
}

/* ============================================================
   MODELS
   ============================================================ */

class ARCXProject {
  String id;
  String name;
  String location;
  String type;
  DateTime createdAt;
  List<Measurement> measurements;

  ARCXProject({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.createdAt,
    List<Measurement>? measurements,
  }) : measurements = measurements ?? [];
}

class Measurement {
  final String type;
  final double value;
  final String unit;
  final DateTime createdAt;

  Measurement({
    required this.type,
    required this.value,
    required this.unit,
    required this.createdAt,
  });
}

class ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/* ============================================================
   MAIN SHELL
   ============================================================ */

class ARCXShell extends StatefulWidget {
  const ARCXShell({super.key});

  @override
  State<ARCXShell> createState() => _ARCXShellState();
}

class _ARCXShellState extends State<ARCXShell> {
  int selectedIndex = 0;

  final List<ARCXProject> projects = [
    ARCXProject(
      id: 'P001',
      name: 'ARCX Demo Project',
      location: 'Tehran',
      type: 'Architecture',
      createdAt: DateTime.now(),
    ),
  ];

  final List<Measurement> measurements = [];

  final List<ModuleItem> modules = const [
    ModuleItem(
      title: 'Field Tools',
      subtitle: 'ابزارهای میدانی',
      icon: Icons.straighten,
    ),
    ModuleItem(
      title: 'Projects',
      subtitle: 'مدیریت پروژه',
      icon: Icons.account_tree_outlined,
    ),
    ModuleItem(
      title: 'Calculators',
      subtitle: 'محاسبات مهندسی',
      icon: Icons.calculate_outlined,
    ),
    ModuleItem(
      title: 'Plans',
      subtitle: 'طراحی پلان',
      icon: Icons.architecture_outlined,
    ),
    ModuleItem(
      title: 'Materials',
      subtitle: 'مصالح و متریال',
      icon: Icons.inventory_2_outlined,
    ),
    ModuleItem(
      title: 'Documentation',
      subtitle: 'مستندسازی',
      icon: Icons.description_outlined,
    ),
    ModuleItem(
      title: 'Finance',
      subtitle: 'مالی پروژه و شخصی',
      icon: Icons.account_balance_wallet_outlined,
    ),
    ModuleItem(
      title: 'Intelligence',
      subtitle: 'هوش معماری',
      icon: Icons.psychology_outlined,
    ),
  ];

  void openModule(String title) {
    switch (title) {
      case 'Field Tools':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FieldToolsPage(
              measurements: measurements,
              onMeasurementAdded: (measurement) {
                setState(() {
                  measurements.add(measurement);
                });
              },
            ),
          ),
        );
        break;

      case 'Projects':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectsPage(
              projects: projects,
              onProjectCreated: (project) {
                setState(() {
                  projects.add(project);
                });
              },
              onProjectDeleted: (project) {
                setState(() {
                  projects.remove(project);
                });
              },
            ),
          ),
        );
        break;

      case 'Calculators':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CalculatorsPage(),
          ),
        );
        break;

      case 'Plans':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PlansPage(),
          ),
        );
        break;

      case 'Materials':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MaterialsPage(),
          ),
        );
        break;

      case 'Documentation':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DocumentationPage(),
          ),
        );
        break;

      case 'Finance':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FinancePage(),
          ),
        );
        break;

      case 'Intelligence':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const IntelligencePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboard(),
      ProjectsPage(
        projects: projects,
        onProjectCreated: (project) {
          setState(() {
            projects.add(project);
          });
        },
        onProjectDeleted: (project) {
          setState(() {
            projects.remove(project);
          });
        },
      ),
      FieldToolsPage(
        measurements: measurements,
        onMeasurementAdded: (measurement) {
          setState(() {
            measurements.add(measurement);
          });
        },
      ),
      const SettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'خانه',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
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
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ARCX',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Architecture & Engineering Intelligence',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ARCXSearchDelegate(
                        modules: modules,
                        onSelected: openModule,
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
            child: _buildOverviewCard(),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final module = modules[index];

                return ModuleCard(
                  module: module,
                  onTap: () => openModule(module.title),
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
          child: SizedBox(height: 25),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    borderRadius: BorderRadius.circular(16),
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
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'هسته مرکزی ARCX',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'v0.1',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                _StatItem(
                  label: 'Projects',
                  value: projects.length.toString(),
                ),
                _StatItem(
                  label: 'Measurements',
                  value: measurements.length.toString(),
                ),
                const _StatItem(
                  label: 'Modules',
                  value: '8',
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Foundation initialized',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: .12,
                minHeight: 7,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'هسته اولیه آماده توسعه ماژول‌های اصلی است.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================
   MODULE CARD
   ============================================================ */

class ModuleCard extends StatelessWidget {
  final ModuleItem module;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.module,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  module.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Text(
                module.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                module.subtitle,
                style: const TextStyle(
                  fontSize: 11,
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
   FIELD TOOLS
   ============================================================ */

class FieldToolsPage extends StatefulWidget {
  final List<Measurement> measurements;
  final ValueChanged<Measurement> onMeasurementAdded;

  const FieldToolsPage({
    super.key,
    required this.measurements,
    required this.onMeasurementAdded,
  });

  @override
  State<FieldToolsPage> createState() =>
      _FieldToolsPageState();
}

class _FieldToolsPageState extends State<FieldToolsPage> {
  final distanceController = TextEditingController();
  final angleController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  String distanceUnit = 'm';

  @override
  void dispose() {
    distanceController.dispose();
    angleController.dispose();
    lengthController.dispose();
    widthController.dispose();
    super.dispose();
  }

  void saveDistance() {
    final value =
        double.tryParse(distanceController.text);

    if (value == null) {
      _message('مقدار فاصله را وارد کنید.');
      return;
    }

    widget.onMeasurementAdded(
      Measurement(
        type: 'Distance',
        value: value,
        unit: distanceUnit,
        createdAt: DateTime.now(),
      ),
    );

    distanceController.clear();
    _message('فاصله ذخیره شد.');
  }

  void saveAngle() {
    final value =
        double.tryParse(angleController.text);

    if (value == null) {
      _message('زاویه را وارد کنید.');
      return;
    }

    widget.onMeasurementAdded(
      Measurement(
        type: 'Angle',
        value: value,
        unit: '°',
        createdAt: DateTime.now(),
      ),
    );

    angleController.clear();
    _message('زاویه ذخیره شد.');
  }

  void calculateArea() {
    final length =
        double.tryParse(lengthController.text);
    final width =
        double.tryParse(widthController.text);

    if (length == null || width == null) {
      _message('طول و عرض را وارد کنید.');
      return;
    }

    final area = length * width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مساحت'),
        content: Text(
          '${area.toStringAsFixed(2)} m²',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Field Tools',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ابزارهای میدانی',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'اندازه‌گیری و برداشت اطلاعات پروژه',
            style: TextStyle(color: Colors.white54),
          ),

          const SizedBox(height: 22),

          _ToolSection(
            icon: Icons.straighten,
            title: 'Distance',
            subtitle: 'اندازه‌گیری فاصله',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: distanceController,
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

          _ToolSection(
            icon: Icons.change_history,
            title: 'Angle',
            subtitle: 'زاویه‌یاب',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: angleController,
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
                  child: const Text('ذخیره'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _ToolSection(
            icon: Icons.crop_square,
            title: 'Area',
            subtitle: 'محاسبه مساحت',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: lengthController,
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
                        controller: widthController,
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: calculateArea,
                    child: const Text(
                      'محاسبه مساحت',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const _ToolSection(
            icon: Icons.water_drop_outlined,
            title: 'Bubble Level',
            subtitle: 'تراز حباب',
          ),

          const SizedBox(height: 12),

          const _ToolSection(
            icon: Icons.screen_rotation_outlined,
            title: 'Inclinometer',
            subtitle: 'شیب‌سنج',
          ),

          const SizedBox(height: 12),

          const _ToolSection(
            icon: Icons.camera_alt_outlined,
            title: 'Camera Measure',
            subtitle:
                'اندازه‌گیری با دوربین و سنسور',
          ),

          const SizedBox(height: 12),

          const _ToolSection(
            icon: Icons.architecture_outlined,
            title: 'Plan Sketch',
            subtitle:
                'طراحی ساده پلان در محل پروژه',
          ),

          const SizedBox(height: 24),

          if (widget.measurements.isNotEmpty) ...[
            const Text(
              'اندازه‌گیری‌های ثبت‌شده',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.measurements.reversed.map(
              (m) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.analytics_outlined,
                  ),
                  title: Text(m.type),
                  subtitle: Text(
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

class _ToolSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;

  const _ToolSection({
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
                  width: 44,
                  height: 44,
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
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
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
   PROJECTS
   ============================================================ */

class ProjectsPage extends StatelessWidget {
  final List<ARCXProject> projects;
  final ValueChanged<ARCXProject> onProjectCreated;
  final ValueChanged<ARCXProject> onProjectDeleted;

  const ProjectsPage({
    super.key,
    required this.projects,
    required this.onProjectCreated,
    required this.onProjectDeleted,
  });

  void createProject(BuildContext context) {
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('پروژه جدید'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'نام پروژه',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'موقعیت',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                return;
              }

              final project = ARCXProject(
                id: DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(),
                name: nameController.text.trim(),
                location:
                    locationController.text.trim(),
                type: 'Architecture',
                createdAt: DateTime.now(),
              );

              onProjectCreated(project);
              Navigator.pop(context);
            },
            child: const Text('ساخت'),
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
          'Projects',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => createProject(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createProject(context),
        icon: const Icon(Icons.add),
        label: const Text('پروژه جدید'),
      ),
      body: projects.isEmpty
          ? const Center(
              child: Text('هنوز پروژه‌ای ساخته نشده است.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(14),
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
                      '${project.location} • ${project.type}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () {
                        onProjectDeleted(project);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* ============================================================
   CALCULATORS
   ============================================================ */

class CalculatorsPage extends StatefulWidget {
  const CalculatorsPage({super.key});

  @override
  State<CalculatorsPage> createState() =>
      _CalculatorsPageState();
}

class _CalculatorsPageState
    extends State<CalculatorsPage> {
  final a = TextEditingController();
  final b = TextEditingController();

  double? result;

  void calculateArea() {
    final x = double.tryParse(a.text);
    final y = double.tryParse(b.text);

    if (x == null || y == null) return;

    setState(() {
      result = x * y;
    });
  }

  @override
  void dispose() {
    a.dispose();
    b.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculators'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'محاسبات',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مساحت مستطیل',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: a,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'طول',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: b,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'عرض',
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: calculateArea,
                    child: const Text('محاسبه'),
                  ),
                  if (result != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      '${result!.toStringAsFixed(2)} m²',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _SimpleModule(
            icon: Icons.square_foot,
            title: 'مساحت',
            subtitle: 'محاسبه مساحت فضاها',
          ),
          const _SimpleModule(
            icon: Icons.view_in_ar_outlined,
            title: 'حجم',
            subtitle: 'محاسبه حجم',
          ),
          const _SimpleModule(
            icon: Icons.percent,
            title: 'درصد و نسبت',
            subtitle: 'محاسبات نسبتی',
          ),
          const _SimpleModule(
            icon: Icons.straighten,
            title: 'تبدیل واحد',
            subtitle: 'mm / cm / m / km',
          ),
        ],
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
        title: const Text('Plans'),
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
            style: TextStyle(color: Colors.white54),
          ),
          SizedBox(height: 24),
          _SimpleModule(
            icon: Icons.grid_4x4,
            title: 'Grid',
            subtitle: 'شبکه ترسیم',
          ),
          _SimpleModule(
            icon: Icons.crop_square,
            title: 'Walls',
            subtitle: 'ترسیم دیوار',
          ),
          _SimpleModule(
            icon: Icons.door_front_door_outlined,
            title: 'Doors',
            subtitle: 'در و بازشو',
          ),
          _SimpleModule(
            icon: Icons.window_outlined,
            title: 'Windows',
            subtitle: 'پنجره',
          ),
          _SimpleModule(
            icon: Icons.square_foot,
            title: 'Dimensions',
            subtitle: 'اندازه‌گذاری',
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
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Materials',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          _SimpleModule(
            icon: Icons.foundation,
            title: 'Concrete',
            subtitle: 'بتن',
          ),
          _SimpleModule(
            icon: Icons.view_agenda_outlined,
            title: 'Steel',
            subtitle: 'فولاد',
          ),
          _SimpleModule(
            icon: Icons.layers_outlined,
            title: 'Wood',
            subtitle: 'چوب',
          ),
          _SimpleModule(
            icon: Icons.texture,
            title: 'Finishes',
            subtitle: 'پوشش و نازک‌کاری',
          ),
          _SimpleModule(
            icon: Icons.search,
            title: 'Material Intelligence',
            subtitle: 'جستجوی هوشمند متریال',
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
  const DocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Documentation',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20),
          _SimpleModule(
            icon: Icons.description_outlined,
            title: 'Project Documents',
            subtitle: 'اسناد پروژه',
          ),
          _SimpleModule(
            icon: Icons.photo_library_outlined,
            title: 'Site Photos',
            subtitle: 'تصاویر کارگاه',
          ),
          _SimpleModule(
            icon: Icons.note_alt_outlined,
            title: 'Notes',
            subtitle: 'یادداشت‌ها',
          ),
          _SimpleModule(
            icon: Icons.checklist,
            title: 'Checklists',
            subtitle: 'چک‌لیست‌ها',
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
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() =>
      _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  double projectIncome = 0;
  double projectExpense = 0;
  double personalIncome = 0;
  double personalExpense = 0;

  @override
  Widget build(BuildContext context) {
    final projectBalance =
        projectIncome - projectExpense;

    final personalBalance =
        personalIncome - personalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTransaction(context),
        child: const Icon(Icons.add),
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
          const SizedBox(height: 6),
          const Text(
            'مالی پروژه و مالی شخصی کاملاً جدا',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 20),

          _FinanceCard(
            title: 'Project Finance',
            subtitle: 'مالی پروژه‌ها',
            balance: projectBalance,
            income: projectIncome,
            expense: projectExpense,
          ),

          const SizedBox(height: 12),

          _FinanceCard(
            title: 'Personal Finance',
            subtitle: 'مالی شخصی',
            balance: personalBalance,
            income: personalIncome,
            expense: personalExpense,
          ),
        ],
      ),
    );
  }

  void _addTransaction(BuildContext context) {
    final amountController = TextEditingController();

    bool isProject = true;
    bool isIncome = true;

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
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'مبلغ',
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('پروژه‌ای'),
                  value: isProject,
                  onChanged: (v) {
                    setLocalState(() {
                      isProject = v;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('درآمد'),
                  value: isIncome,
                  onChanged: (v) {
                    setLocalState(() {
                      isIncome = v;
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
                  final amount =
                      double.tryParse(
                    amountController.text,
                  );

                  if (amount == null) return;

                  setState(() {
                    if (isProject) {
                      if (isIncome) {
                        projectIncome += amount;
                      } else {
                        projectExpense += amount;
                      }
                    } else {
                      if (isIncome) {
                        personalIncome += amount;
                      } else {
                        personalExpense += amount;
                      }
                    }
                  });

                  Navigator.pop(context);
                },
                child: const Text('ثبت'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double balance;
  final double income;
  final double expense;

  const _FinanceCard({
    required this.title,
    required this.subtitle,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              balance.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
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
        title: const Text('Intelligence'),
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
            'لایه هوشمند معماری و مهندسی',
            style: TextStyle(color: Colors.white54),
          ),
          SizedBox(height: 24),
          _SimpleModule(
            icon: Icons.auto_awesome,
            title: 'AI Assistant',
            subtitle: 'دستیار معماری',
          ),
          _SimpleModule(
            icon: Icons.analytics_outlined,
            title: 'Project Analysis',
            subtitle: 'تحلیل پروژه',
          ),
          _SimpleModule(
            icon: Icons.lightbulb_outline,
            title: 'Design Suggestions',
            subtitle: 'پیشنهاد طراحی',
          ),
          _SimpleModule(
            icon: Icons.warning_amber_outlined,
            title: 'Risk Detection',
            subtitle: 'شناسایی ریسک',
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
        title: const Text('Settings'),
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
            title: Text('Language'),
            subtitle: Text('فارسی / English'),
          ),
          ListTile(
            leading: Icon(Icons.cloud_outlined),
            title: Text('Cloud Sync'),
            subtitle: Text('آماده توسعه'),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Local Storage'),
            subtitle: Text('ذخیره‌سازی محلی'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('ARCX Version'),
            subtitle: Text('0.1 Foundation'),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   SIMPLE MODULE
   ============================================================ */

class _SimpleModule extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SimpleModule({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}

/* ============================================================
   STAT
   ============================================================ */

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
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
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
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

/* ============================================================
   SEARCH
   ============================================================ */

class ARCXSearchDelegate
    extends SearchDelegate<String> {
  final List<ModuleItem> modules;
  final ValueChanged<String> onSelected;

  ARCXSearchDelegate({
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
          onPressed: () {
            query = '';
          },
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
    return _results(context);
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _results(context);
  }

  Widget _results(BuildContext context) {
    final results = modules.where((module) {
      final q = query.toLowerCase();

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