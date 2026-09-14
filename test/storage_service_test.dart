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

    test('saves and reads a project', () async {
      final project = Project(
        id: 'test-project-1',
        name: 'پروژه تست ARCX',
        location: 'تهران',
        category: 'مسکونی',
      );

      await storage.saveProject(project);

      final loaded = storage.getProject('test-project-1');

      expect(loaded, isNotNull);
      expect(loaded!.name, equals('پروژه تست ARCX'));
      expect(loaded.location, equals('تهران'));
      expect(loaded.category, equals('مسکونی'));
    });

    test('saves and reads a finance transaction', () async {
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

      final loaded = storage
          .getTransactions()
          .firstWhere(
            (item) => item.id == transaction.id,
          );

      expect(loaded.title, equals('هزینه تست'));
      expect(loaded.amount, equals(250000));
      expect(loaded.income, isFalse);
      expect(loaded.projectRelated, isTrue);
      expect(loaded.projectId, equals('test-project-1'));
    });

    test('saves and reads a material', () async {
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

      final loaded = storage
          .getMaterials()
          .firstWhere(
            (item) => item.id == material.id,
          );

      expect(loaded.name, equals('بتن C30'));
      expect(loaded.category, equals('سازه'));
      expect(loaded.unit, equals('m³'));
      expect(loaded.price, equals(5000000));
    });

    test('saves and reads a project element', () async {
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

      await storage.saveProjectElement(element);

      final loaded = storage
          .getProjectElements('test-project-1')
          .firstWhere(
            (item) => item.id == element.id,
          );

      expect(loaded.name, equals('دیوار تست'));
      expect(
        loaded.type,
        equals(ProjectElementType.wall),
      );
      expect(loaded.x, equals(10));
      expect(loaded.y, equals(20));
      expect(loaded.width, equals(500));
      expect(loaded.height, equals(300));
      expect(loaded.rotation, equals(90));
      expect(
        loaded.properties['thickness'],
        equals(20),
      );
      expect(
        loaded.properties['material'],
        equals('brick'),
      );
    });

    test('saves and reads user profile', () async {
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

      final loaded = storage.getUserProfile();

      expect(loaded, isNotNull);
      expect(loaded!.id, equals('user-test-1'));
      expect(loaded.name, equals('ARCX Test User'));
      expect(loaded.email, equals('test@arcx.local'));
      expect(loaded.profession, equals('Architect'));
      expect(loaded.city, equals('Tehran'));
    });

    test('deleting a project also deletes its elements', () async {
      final project = Project(
        id: 'delete-project-test',
        name: 'پروژه حذف',
        location: '',
        category: 'تست',
      );

      final element = ProjectElement(
        id: 'delete-element-test',
        projectId: project.id,
        name: 'عنصر وابسته',
        type: ProjectElementType.wall,
      );

      await storage.saveProject(project);
      await storage.saveProjectElement(element);

      expect(
        storage
            .getProjectElements(project.id)
            .any(
              (item) => item.id == element.id,
            ),
        isTrue,
      );

      await storage.deleteProject(project.id);

      expect(
        storage.getProject(project.id),
        isNull,
      );

      expect(
        storage.getProjectElements(project.id),
        isEmpty,
      );
    });

    test('clearAll removes ARCX data', () async {
      await storage.clearAll();

      expect(storage.getProjects(), isEmpty);
      expect(storage.getTransactions(), isEmpty);
      expect(storage.getMaterials(), isEmpty);
      expect(storage.getProjectElements('test-project-1'), isEmpty);
      expect(storage.getUserProfile(), isNull);
    });
  });
}