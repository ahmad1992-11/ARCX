import 'package:flutter_test/flutter_test.dart';

import 'package:arcx/models/finance_transaction.dart';
import 'package:arcx/models/material.dart';
import 'package:arcx/models/project.dart';
import 'package:arcx/models/project_element.dart';
import 'package:arcx/models/user_profile.dart';

void main() {
  group('Model JSON serialization', () {
    test('Project round trip', () {
      final original = Project(
        id: 'project-1',
        name: 'پروژه معماری',
        location: 'کرج',
        category: 'مسکونی',
        status: 'Active',
        createdAt: DateTime(2026, 9, 15),
        measurements: [
          Measurement(
            type: 'طول زمین',
            value: 25.5,
            unit: 'm',
            date: DateTime(2026, 9, 15),
          ),
        ],
        notes: [
          NoteItem(
            title: 'یادداشت تست',
            text: 'یادداشت آزمایشی ARCX',
            date: DateTime(2026, 9, 15),
          ),
        ],
      );

      final restored = Project.fromJson(original.toJson());

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.location, equals(original.location));
      expect(restored.category, equals(original.category));

      expect(restored.measurements.length, equals(1));
      expect(restored.measurements.first.type, equals('طول زمین'));
      expect(restored.measurements.first.value, equals(25.5));
      expect(restored.measurements.first.unit, equals('m'));

      expect(restored.notes.length, equals(1));
      expect(restored.notes.first.title, equals('یادداشت تست'));
      expect(
        restored.notes.first.text,
        equals('یادداشت آزمایشی ARCX'),
      );
    });

    test('FinanceTransaction round trip', () {
      final original = FinanceTransaction(
        id: 'finance-1',
        title: 'درآمد پروژه',
        amount: 12000000,
        income: true,
        projectRelated: true,
        projectId: 'project-1',
        date: DateTime(2026, 9, 15),
        description: 'تست مالی',
      );

      final restored = FinanceTransaction.fromJson(
        original.toJson(),
      );

      expect(restored.id, equals(original.id));
      expect(restored.title, equals(original.title));
      expect(restored.amount, equals(original.amount));
      expect(restored.income, isTrue);
      expect(restored.projectRelated, isTrue);
      expect(restored.projectId, equals('project-1'));
      expect(restored.description, equals('تست مالی'));
    });

    test('Material round trip', () {
      final original = MaterialItem(
        id: 'material-1',
        name: 'آجر',
        category: 'دیوارچینی',
        unit: 'عدد',
        price: 25000,
        brand: 'Test',
        color: 'قرمز',
        description: 'تست متریال',
      );

      final restored = MaterialItem.fromJson(
        original.toJson(),
      );

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.category, equals(original.category));
      expect(restored.unit, equals(original.unit));
      expect(restored.price, equals(original.price));
      expect(restored.description, equals(original.description));
    });

    test('ProjectElement round trip', () {
      final original = ProjectElement(
        id: 'element-1',
        projectId: 'project-1',
        name: 'پنجره',
        type: ProjectElementType.window,
        x: 100,
        y: 200,
        width: 120,
        height: 150,
        rotation: 15,
        properties: {
          'material': 'aluminium',
          'doubleGlazed': true,
        },
      );

      final restored = ProjectElement.fromJson(
        original.toJson(),
      );

      expect(restored.id, equals(original.id));
      expect(restored.projectId, equals(original.projectId));
      expect(restored.name, equals(original.name));
      expect(
        restored.type,
        equals(ProjectElementType.window),
      );
      expect(restored.x, equals(100));
      expect(restored.y, equals(200));
      expect(restored.width, equals(120));
      expect(restored.height, equals(150));
      expect(restored.rotation, equals(15));
      expect(
        restored.properties['material'],
        equals('aluminium'),
      );
      expect(
        restored.properties['doubleGlazed'],
        equals(true),
      );
    });

    test('UserProfile round trip', () {
      final original = UserProfile(
        id: 'user-1',
        name: 'Ahmad',
        email: 'ahmad@example.com',
        phone: '09120000000',
        profession: 'Architect',
        country: 'Iran',
        city: 'Karaj',
      );

      final restored = UserProfile.fromJson(
        original.toJson(),
      );

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.email, equals(original.email));
      expect(restored.phone, equals(original.phone));
      expect(restored.profession, equals(original.profession));
      expect(restored.country, equals(original.country));
      expect(restored.city, equals(original.city));
    });
  });
}