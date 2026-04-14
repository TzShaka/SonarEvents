import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/Usuarios/Logica/estudiante.dart';

// ---------------------------------------------------------------------------
// Helper: envuelve el widget con un Navigator (necesario para push/pop)
// ---------------------------------------------------------------------------
Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

// ---------------------------------------------------------------------------
// Constantes de control
// ---------------------------------------------------------------------------
const _loading = <String, dynamic>{'__state__': 'loading'};

// ---------------------------------------------------------------------------
// Datos de prueba reutilizables
// ---------------------------------------------------------------------------

/// Estudiante con todos los campos opcionales presentes
const Map<String, dynamic> _fullData = {
  'name':     'Juan Pérez',
  'filial':   'Filial Juliaca',
  'facultad': 'Ingeniería',
  'carrera':  'Ingeniería de Sistemas',
};

/// Estudiante sin campos opcionales (solo nombre)
const Map<String, dynamic> _soloNombreData = {
  'name': 'Ana López',
};

/// Estudiante con solo filial (sin facultad ni carrera)
const Map<String, dynamic> _soloFilialData = {
  'name':   'Carlos Ruiz',
  'filial': 'Filial Arequipa',
};

/// Estudiante con solo facultad
const Map<String, dynamic> _soloFacultadData = {
  'name':     'María Torres',
  'facultad': 'Ciencias',
};

/// Estudiante con solo carrera
const Map<String, dynamic> _soloCarreraData = {
  'name':    'Pedro Salas',
  'carrera': 'Medicina Humana',
};

/// Mapa con name vacío — fuerza el fallback a 'Estudiante'
const Map<String, dynamic> _emptyNameData = {
  'name':     '',
  'filial':   '',
  'facultad': '',
  'carrera':  '',
};

/// Datos con texto muy largo para probar overflow
const Map<String, dynamic> _longNameData = {
  'name':     'Bartholomew Alejandro Gutiérrez Valenzuela De La Cruz',
  'filial':   'Filial Norte Extendida Zona Industrial',
  'facultad': 'Facultad de Ingeniería Mecánica Eléctrica y de Sistemas',
  'carrera':  'Ingeniería de Sistemas e Informática Aplicada',
};

// ---------------------------------------------------------------------------

void main() {
  // =========================================================================
  // Grupo 1 – Estado de carga (loading)
  // =========================================================================
  group('Estado loading', () {
    testWidgets('muestra CircularProgressIndicator mientras carga',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('muestra texto "Cargando..." en estado loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _loading),
      ));

      expect(find.text('Cargando...'), findsOneWidget);
    });

    testWidgets('no muestra "Panel de Estudiante" mientras carga',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _loading),
      ));

      expect(find.text('Panel de Estudiante'), findsNothing);
    });

    testWidgets('el fondo en loading es el azul oscuro', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _loading),
      ));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1E3A5F));
    });
  });

  // =========================================================================
  // Grupo 2 – Header y estructura principal
  // =========================================================================
  group('Header y estructura principal', () {
    testWidgets('muestra "Panel de Estudiante" en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Panel de Estudiante'), findsOneWidget);
    });

    testWidgets('el Scaffold tiene fondo azul oscuro', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1E3A5F));
    });

    testWidgets('existe un SafeArea como contenedor raíz', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('muestra el icono de logout en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.logout), findsWidgets);
    });

    testWidgets('el logo usa errorBuilder sin lanzar excepción',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 3 – Tarjeta de bienvenida
  // =========================================================================
  group('Tarjeta de bienvenida', () {
    testWidgets('muestra el nombre del estudiante', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.textContaining('Juan Pérez'), findsOneWidget);
    });

    testWidgets('muestra "Bienvenido," antes del nombre', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.textContaining('Bienvenido,'), findsOneWidget);
    });

    testWidgets('muestra el icono de waving_hand en la bienvenida',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.waving_hand), findsOneWidget);
    });

    testWidgets('fallback a "Estudiante" cuando name está vacío',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _emptyNameData),
      ));
      await tester.pump();

      expect(find.textContaining('Estudiante'), findsWidgets);
    });

    testWidgets('nombres largos no generan excepción de overflow',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _longNameData),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 4 – Chips de información (filial, facultad, carrera)
  // =========================================================================
  group('Chips de información', () {
    testWidgets('muestra el Divider cuando hay al menos un chip',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('no muestra Divider cuando no hay ningún chip', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _emptyNameData),
      ));
      await tester.pump();

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('muestra chip de filial cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Filial Juliaca'), findsOneWidget);
    });

    testWidgets('muestra chip de facultad cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ingeniería'), findsOneWidget);
    });

    testWidgets('muestra chip de carrera cuando existe', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ingeniería de Sistemas'), findsOneWidget);
    });

    testWidgets('icono location_city aparece cuando hay filial', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloFilialData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.location_city), findsOneWidget);
    });

    testWidgets('icono account_balance aparece cuando hay facultad',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloFacultadData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.account_balance), findsOneWidget);
    });

    testWidgets('icono menu_book aparece cuando hay carrera', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloCarreraData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.menu_book), findsOneWidget);
    });

    testWidgets('sin chips no aparecen iconos de categoría', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloNombreData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.location_city),   findsNothing);
      expect(find.byIcon(Icons.account_balance), findsNothing);
      expect(find.byIcon(Icons.menu_book),       findsNothing);
    });

    testWidgets('chips con texto largo no crashean', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _longNameData),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 5 – Tarjetas del menú (GridView)
  // =========================================================================
  group('Tarjetas del menú', () {
    testWidgets('muestra la tarjeta "Mi Perfil"', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Mi Perfil'), findsOneWidget);
    });

    testWidgets('muestra la tarjeta "Escanear QR"', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Escanear QR'), findsOneWidget);
    });

    testWidgets('muestra la tarjeta "Mis Asistencias"', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Mis Asistencias'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de Mi Perfil', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ver información personal'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de Escanear QR', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Registrar asistencia'), findsOneWidget);
    });

    testWidgets('muestra subtítulo de Mis Asistencias', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.text('Ver historial de asistencias'), findsOneWidget);
    });

    testWidgets('el GridView tiene exactamente 3 Cards', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('el GridView usa crossAxisCount = 2', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('tap en Mi Perfil no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.text('Mi Perfil'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tap en Escanear QR no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.text('Escanear QR'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tap en Mis Asistencias no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.text('Mis Asistencias'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 6 – Diálogo de advertencia (primera vez)
  // =========================================================================
  group('Diálogo advertencia primera vez', () {
    testWidgets('muestra el diálogo cuando testShowWarning = true',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('⚠️ Atención importante'), findsOneWidget);
    });

    testWidgets('no muestra el diálogo cuando testShowWarning no se pasa',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('⚠️ Atención importante'), findsNothing);
    });

    testWidgets('el botón está deshabilitado durante la cuenta regresiva',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Entendido ('), findsOneWidget);

      final btn = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.textContaining('Entendido ('),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets('el botón se habilita después de 5 segundos', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 6));

      expect(find.text('Entendido'), findsOneWidget);

      final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Entendido'),
      );
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('pulsar "Entendido" cierra el diálogo', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(seconds: 6));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Entendido'));
      await tester.pumpAndSettle();

      expect(find.text('⚠️ Atención importante'), findsNothing);
    });

    testWidgets('el diálogo muestra el bloque rojo de alerta', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('Solo puedes iniciar sesión UNA VEZ'),
        findsOneWidget,
      );
    });

    testWidgets('el diálogo muestra el bloque azul de recomendación',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Mantén la app abierta'), findsOneWidget);
    });

    testWidgets('el diálogo muestra el icono de advertencia amber',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
    });

    testWidgets('el diálogo no es descartable por toque fuera', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(
          testOverrideData: _fullData,
          testShowWarning: true,
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      expect(find.text('⚠️ Atención importante'), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 7 – Diálogo de confirmación de logout
  // =========================================================================
  group('Diálogo de logout', () {
    testWidgets('pulsar logout abre el diálogo de confirmación',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle();

      expect(find.text('Cerrar Sesión'), findsWidgets);
      expect(
        find.text('¿Estás seguro de que deseas cerrar sesión?'),
        findsOneWidget,
      );
    });

    testWidgets('pulsar "Cancelar" cierra el diálogo sin navegar',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Panel de Estudiante'), findsOneWidget);
    });

    testWidgets('el diálogo muestra la advertencia de no poder reingresar',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('no podrás volver a ingresar'),
        findsOneWidget,
      );
    });

    testWidgets('el diálogo no es descartable por toque fuera', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      expect(
        find.text('¿Estás seguro de que deseas cerrar sesión?'),
        findsOneWidget,
      );
    });
  });

  // =========================================================================
  // Grupo 8 – Layout y área de contenido
  // =========================================================================
  group('Layout y área de contenido', () {
    testWidgets('el área inferior tiene color claro', (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      final containers = tester.widgetList<Container>(find.byType(Container));
      final lightContainer = containers.any((c) {
        final d = c.decoration;
        if (d is BoxDecoration) return d.color == const Color(0xFFE8EDF2);
        return false;
      });
      expect(lightContainer, isTrue);
    });

    testWidgets('el área inferior tiene bordes superiores redondeados',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _fullData),
      ));
      await tester.pump();

      final containers = tester.widgetList<Container>(find.byType(Container));
      final roundedTop = containers.any((c) {
        final d = c.decoration;
        if (d is BoxDecoration && d.borderRadius != null) {
          final br = d.borderRadius as BorderRadius;
          return br.topLeft.x > 0 && br.topRight.x > 0;
        }
        return false;
      });
      expect(roundedTop, isTrue);
    });

    testWidgets('datos mínimos (solo nombre) renderizan sin excepción',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloNombreData),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Ana López'), findsOneWidget);
    });

    testWidgets('solo filial no muestra chips de facultad ni carrera',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const EstudianteScreen(testOverrideData: _soloFilialData),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.account_balance), findsNothing);
      expect(find.byIcon(Icons.menu_book),       findsNothing);
    });
  });
}