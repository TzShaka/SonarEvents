import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/Usuarios/Logica/perfil.dart';

// ---------------------------------------------------------------------------
// Helper para bombear el widget con un Navigator (necesario para pop)
// ---------------------------------------------------------------------------
Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

// ---------------------------------------------------------------------------
// Constantes de control — DEBEN estar antes de su primer uso
// ---------------------------------------------------------------------------
const _loading  = <String, dynamic>{'__state__': 'loading'};
const _errorNull = <String, dynamic>{'__state__': 'error'};

// ---------------------------------------------------------------------------
// Datos de prueba reutilizables
// ---------------------------------------------------------------------------
const Map<String, dynamic> _fullData = {
  'name': 'Juan Pérez',
  'username': 'jperez',
  'email': 'juan@gmail.com',
  'correoInstitucional': 'jperez@uni.edu',
  'dni': '12345678',
  'celular': '987654321',
  'codigoUniversitario': 'U2021001',
  'facultad': 'Ingeniería',
  'carrera': 'Ingeniería de Sistemas',
  'sede': 'Lima Norte',
  'filial': 'Filial Lima',
  'modalidadEstudio': 'Presencial',
  'modoContrato': 'Regular',
  'ciclo': '5',
  'grupo': 'A',
};

const Map<String, dynamic> _minimalData = {
  'name': 'Ana López',
  'username': 'alopez',
  'email': 'ana@gmail.com',
  'dni': '87654321',
  'codigoUniversitario': 'U2022002',
  'facultad': 'Ciencias',
  'carrera': 'Biología',
};

const Map<String, dynamic> _filialOnlyData = {
  'name': 'Carlos Ruiz',
  'username': 'cruiz',
  'email': 'carlos@gmail.com',
  'dni': '11223344',
  'codigoUniversitario': 'U2023003',
  'facultad': 'Derecho',
  'carrera': 'Derecho',
  'filial': 'Filial Arequipa',
};

const Map<String, dynamic> _noSedeData = {
  'name': 'María Torres',
  'username': 'mtorres',
  'email': 'maria@gmail.com',
  'dni': '55667788',
  'codigoUniversitario': 'U2024004',
  'facultad': 'Medicina',
  'carrera': 'Medicina Humana',
};

// ---------------------------------------------------------------------------
// Fixture para cubrir la rama _buildNoData()
// El widget llega a _buildNoData cuando _userData != null pero está vacío
// y _isLoading == false y _errorMessage == null.
// Pasamos un mapa con solo el campo 'name' vacío para que no crashee al
// acceder _userData!['name'], pero sin campos mínimos requeridos.
// ---------------------------------------------------------------------------
const Map<String, dynamic> _emptyNameData = {
  'name': '',
  'username': '',
  'email': '',
  'dni': '',
  'codigoUniversitario': '',
  'facultad': '',
  'carrera': '',
};

void main() {
  // =========================================================================
  // Grupo 1 – Estado de carga (loading)
  // =========================================================================
  group('Estado loading', () {
    testWidgets('muestra indicador de carga mientras obtiene datos',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando información...'), findsOneWidget);
    });

    testWidgets('no muestra perfil mientras está cargando', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _loading),
      ));

      expect(find.text('Mi Perfil'), findsOneWidget); // AppBar sí
      expect(find.text('Estudiante'), findsNothing);  // Perfil no
    });
  });

  // =========================================================================
  // Grupo 2 – Estado de error
  // =========================================================================
  group('Estado error', () {
    testWidgets('muestra mensaje de error cuando los datos son null',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _errorNull),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(
        find.text('No se pudo cargar la información del usuario'),
        findsOneWidget,
      );
    });

    testWidgets('botón Reintentar existe en estado de error', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _errorNull),
      ));
      await tester.pump();

      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('tap en Reintentar vuelve a intentar carga', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _errorNull),
      ));
      await tester.pump();

      await tester.tap(find.text('Reintentar'));
      await tester.pump();

      // Después del tap el override sigue siendo _errorNull, por lo tanto
      // el widget muestra el error nuevamente — no crashea.
      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 3 – Perfil completo (todos los campos opcionales presentes)
  // =========================================================================
  group('Perfil completo', () {
    testWidgets('muestra nombre del usuario', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Juan Pérez'), findsOneWidget);
    });

    testWidgets('muestra badge Estudiante', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Estudiante'), findsOneWidget);
    });

    testWidgets('muestra badge de sede en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      // El badge muestra 'Lima Norte' (sede tiene prioridad sobre filial)
      expect(find.text('Lima Norte'), findsWidgets);
    });

    testWidgets('sección Información Personal es visible', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Información Personal'), findsOneWidget);
    });

    testWidgets('sección Información Académica es visible', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Información Académica'), findsOneWidget);
    });

    testWidgets('muestra username', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('jperez'), findsOneWidget);
    });

    testWidgets('muestra email personal', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('juan@gmail.com'), findsOneWidget);
    });

    testWidgets('muestra correo institucional cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('jperez@uni.edu'), findsOneWidget);
    });

    testWidgets('muestra DNI', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('12345678'), findsOneWidget);
    });

    testWidgets('muestra celular cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('987654321'), findsOneWidget);
    });

    testWidgets('muestra código universitario', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('U2021001'), findsOneWidget);
    });

    testWidgets('muestra facultad', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ingeniería'), findsOneWidget);
    });

    testWidgets('muestra carrera', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
    });

    testWidgets('muestra modalidad de estudio cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Presencial'), findsOneWidget);
    });

    testWidgets('muestra modo contrato cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Regular'), findsOneWidget);
    });

    // FIX: las tarjetas de ciclo/grupo pueden estar fuera del viewport;
    // hacemos scroll hasta encontrarlas antes de verificar.
    testWidgets('muestra ciclo con prefijo cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text('Ciclo 5'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Ciclo 5'), findsOneWidget);
    });

    testWidgets('muestra grupo con prefijo cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text('Grupo A'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Grupo A'), findsOneWidget);
    });

    testWidgets('la tarjeta Filial / Sede muestra el valor correcto',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Lima Norte'), findsWidgets);
    });
  });

  // =========================================================================
  // Grupo 4 – Lógica _getSede: prioridad sede > filial > null
  // =========================================================================
  group('Lógica de sede/filial', () {
    testWidgets('usa filial cuando no hay sede', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _filialOnlyData),
      ));
      await tester.pump();

      expect(find.text('Filial Arequipa'), findsWidgets);
    });

    testWidgets('no muestra badge de sede si ambos campos están vacíos',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _noSedeData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.location_city), findsNothing);
    });
  });

  // =========================================================================
  // Grupo 5 – Datos mínimos (campos opcionales ausentes)
  // =========================================================================
  group('Perfil con datos mínimos', () {
    testWidgets('no muestra correo institucional si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      expect(find.text('Email Institucional'), findsNothing);
    });

    testWidgets('no muestra celular si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      expect(find.text('Celular'), findsNothing);
    });

    testWidgets('no muestra modalidad de estudio si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      expect(find.text('Modalidad de Estudio'), findsNothing);
    });

    testWidgets('no muestra modo contrato si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      expect(find.text('Modo Contrato'), findsNothing);
    });

    testWidgets('no muestra ciclo si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      // El prefijo 'Ciclo' solo aparece si el campo existe
      expect(find.textContaining('Ciclo'), findsNothing);
    });

    testWidgets('no muestra grupo si no existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _minimalData),
      ));
      await tester.pump();

      // El prefijo 'Grupo' solo aparece si el campo existe
      expect(find.textContaining('Grupo'), findsNothing);
    });

    testWidgets('muestra "No disponible" para campos requeridos vacíos',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: {'name': 'Test'}),
      ));
      await tester.pump();

      expect(find.text('No disponible'), findsWidgets);
    });

    testWidgets('muestra "Sin nombre" cuando name está ausente', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _emptyNameData),
      ));
      await tester.pump();

      expect(find.text('Sin nombre'), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 6 – AppBar y navegación
  // =========================================================================
  group('AppBar', () {
    testWidgets('muestra título Mi Perfil', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Mi Perfil'), findsOneWidget);
    });

    testWidgets('botón de retroceso existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('botón de refresh existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('tap en refresh no genera excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tap en refresh con estado de error no genera excepción',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _errorNull),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 7 – Scroll y layout
  // =========================================================================
  group('Layout y scroll', () {
    testWidgets('el contenido es scrolleable', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('el avatar circular existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Hero tag profile_avatar presente en el árbol', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byType(Hero), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 8 – Cobertura de la rama _buildNoData()
  // _buildNoData se alcanza cuando _userData != null pero todos sus valores
  // son strings vacíos (isNotEmpty == false para los campos mostrados).
  // En este caso el widget renderiza el perfil con "Sin nombre" y
  // "No disponible", cubriendo también _buildNoData indirectamente a través
  // del flujo. Para forzar _buildNoData directamente sería necesario
  // modificar el widget; este test al menos ejercita el camino de datos vacíos.
  // =========================================================================
  group('Campos en blanco / Sin datos', () {
    testWidgets('campos todos vacíos muestra "Sin nombre" y "No disponible"',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _emptyNameData),
      ));
      await tester.pump();

      expect(find.text('Sin nombre'), findsOneWidget);
      expect(find.text('No disponible'), findsWidgets);
    });

    testWidgets('campos vacíos no muestran badge de sede', (tester) async {
      await tester.pumpWidget(_wrap(
        const PerfilScreen(testOverrideData: _emptyNameData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.location_city), findsNothing);
    });
  });
}