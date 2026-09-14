 import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:arcx/models/finance_transaction.dart';
import 'package:arcx/models/material.dart';
import 'package:arcx/models/project.dart';
import 'package:arcx/models/project_element.dart';
import 'package:arcx/models/user_profile.dart';
import 'package:arcx/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService persistence', () {
    late StorageService storage;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});

      storage = StorageService.instance;
      await storage.initialize();
    });

    test('saves and loads a project', () async {
      final project = Project(
        id: 'test-project-1',
        name: 'پروژه تست ARCX',
        description: 'پروژه آزمایشی ذخیره‌سازی',
        location: 'تهران',
        clientName: 'کارفرمای تست',
        createdAt: DateTime(2026, 9, 15),
      );

      await storage.saveProject(project);

      final loaded = storage.projects.firstWhere(
        (item) => item.id == project.id,
      );

      expect(loaded.name, equals(project.name));
      expect(loaded.description, equals(project.description));
      expect(loaded.location, equals(project.location));
      expect(loaded.clientName, equals(project.clientName));
    });

    test('saves a finance transaction', () async {
      final transaction = FinanceTransaction(
        id: 'transaction-test-1',
        title: 'هزینه تست',
        amount: 250000,
        income: false,
        projectRelated: true,
        projectId: 'test-project-1',
        date: DateTime(2026, 9, 15),
        description: 'تراکنش آزمایشی',
      );

      await storage.saveTransaction(transaction);

      final loaded = storage.transactions.firstWhere(
        (item) => item.id == transaction.id,
      );

      expect(loaded.title, equals(transaction.title));
      expect(loaded.amount, equals(transaction.amount));
      expect(loaded.income, equals(false));
      expect(loaded.projectRelated, equals(true));
      expect(loaded.projectId, equals('test-project-1'));
    });

    test('saves a material', () async {
      final material = MaterialItem(
        id: 'material-test-1',
        name: 'بتن C30',
        category: 'سازه',
        unit: 'm³',
        price: 5000000,
        brand: 'Test Brand',
        color: 'خاکستری',
        description: 'متریال آزمایشی',
      );

      await storage.saveMaterial(material);

      final loaded = storage.materials.firstWhere(
        (item) => item.id == material.id,
      );

      expect(loaded.name, equals(material.name));
      expect(loaded.category, equals(material.category));
      expect(loaded.unit, equals(material.unit));
      expect(loaded.price, equals(material.price));
    });

    test('saves a project element', () async {
      final element = ProjectElement(
        id: 'element-test-1',
        projectId: 'test-project-1',
        name: 'دیوار تست',
        type: ProjectElementType.wall,
        x: 10,
        y: 20,
        width: 500,
        height: 300,
        rotation: 90,
        properties: {
          'thickness': 20,
          'material': 'brick',
        },
      );

      await storage.saveElement(element);

      final loaded = storage.elements.firstWhere(
        (item) => item.id == element.id,
      );

      expect(loaded.name, equals(element.name));
      expect(loaded.type, equals(ProjectElementType.wall));
      expect(loaded.x, equals(10));
      expect(loaded.y, equals(20));
      expect(loaded.width, equals(500));
      expect(loaded.height, equals(300));
      expect(loaded.rotation, equals(90));
      expect(loaded.properties['thickness'], equals(20));
      expect(loaded.properties['material'], equals('brick'));
    });

    test('saves user profile', () async {
      final profile = UserProfile(
        id: 'user-test-1',
        name: 'ARCX Test User',
        email: 'test@arcx.local',
        phone: '09120000000',
        profession: 'Architect',
        country: 'Iran',
        city: 'Tehran',
      );

      await storage.saveUserProfile(profile);

      final loaded = storage.userProfile;

      expect(loaded, isNotNull);
      expect(loaded!.id, equals(profile.id));
      expect(loaded.name, equals(profile.name));
      expect(loaded.email, equals(profile.email));
      expect(loaded.profession, equals(profile.profession));
      expect(loaded.city, equals(profile.city));
    });

    test('deleting a project also deletes its elements', () async {
      final project = Project(
        id: 'delete-project-test',
        name: 'پروژه حذف',
        description: '',
        location: '',
        clientName: '',
        createdAt: DateTime(2026, 9, 15),
      );

      final element = ProjectElement(
        id: 'delete-element-test',
        projectId: project.id,
        name: 'عنصر وابسته',
        type: ProjectElementType.wall,
      );

      await storage.saveProject(project);
      await storage.saveElement(element);

      expect(
        storage.elements.any((item) => item.projectId == project.id),
        isTrue,
      );

      await storage.deleteProject(project.id);

      expect(
        storage.projects.any((item) => item.id == project.id),
        isFalse,
      );

      expect(
        storage.elements.any((item) => item.projectId == project.id),
        isFalse,
      );
    });

    test('clearAll removes persisted ARCX data', () async {
      await storage.clearAll();

      expect(storage.projects, isEmpty);
      expect(storage.transactions, isEmpty);
      expect(storage.materials, isEmpty);
      expect(storage.elements, isEmpty);
      expect(storage.userProfile, isNull);
    });
  });
}