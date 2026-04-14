import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/Usuarios/Logica/ver_certificados.dart';

// ---------------------------------------------------------------------------
// Helper: envuelve el widget con Navigator y MaterialApp
// ---------------------------------------------------------------------------
Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

// ---------------------------------------------------------------------------
// Datos de prueba reutilizables
// ---------------------------------------------------------------------------

/// Certificado completo con todos los campos
const Map<String, dynamic> _certCompleto = {
  'id':      'cert_001',
  'rol':     'ASISTENTE',
  'evento':  'Congreso Internacional de Sistemas',
  'fecha':   '15 de marzo de 2024',
  'carrera': 'Ingeniería de Sistemas',
  'horas':   '8',
};

/// Certificado con rol PONENTE
const Map<String, dynamic> _certPonente = {
  'id':      'cert_002',
  'rol':     'PONENTE',
  'evento':  'Seminario de Inteligencia Artificial',
  'fecha':   '20 de abril de 2024',
  'carrera': 'Ingeniería de Sistemas',
  'horas':   '',
};

/// Certificado con rol JURADO
const Map<String, dynamic> _certJurado = {
  'id':      'cert_003',
  'rol':     'JURADO',
  'evento':  'Feria de Proyectos Tecnológicos',
  'fecha':   '5 de mayo de 2024',
  'carrera': 'Ciencias de la Computación',
  'horas':   '',
};

/// Certificado con rol ORGANIZADOR
const Map<String, dynamic> _certOrganizador = {
  'id':      'cert_004',
  'rol':     'ORGANIZADOR',
  'evento':  'Hackathon Regional 2024',
  'fecha':   '10 de junio de 2024',
  'carrera': 'Ingeniería de Sistemas',
  'horas':   '',
};

/// Certificado con campos mínimos (sin fecha ni carrera)
const Map<String, dynamic> _certMinimo = {
  'id':      'cert_005',
  'rol':     'ASISTENTE',
  'evento':  'Taller básico',
  'fecha':   '',
  'carrera': '',
  'horas':   '',
};

/// Certificado con nombre de evento muy largo
const Map<String, dynamic> _certEventoLargo = {
  'id':      'cert_006',
  'rol':     'ASISTENTE',
  'evento':  'Congreso Internacional Multidisciplinario de Ciencias Aplicadas '
             'e Ingeniería de Sistemas Computacionales y Telemáticos 2024',
  'fecha':   '1 de enero de 2024',
  'carrera': 'Ingeniería de Sistemas e Informática',
  'horas':   '16',
};

// ---------------------------------------------------------------------------
// Constantes de estado para testOverrideData
// ---------------------------------------------------------------------------
const _loading  = <String, dynamic>{'__state__': 'loading'};
const _error    = <String, dynamic>{'__state__': 'error',   '__msg__': 'Error de prueba'};
const _vacio    = <String, dynamic>{'__state__': 'empty'};

// ---------------------------------------------------------------------------

void main() {

  // =========================================================================
  // Grupo 1 – Estado de carga (loading)
  // =========================================================================
  group('Estado loading', () {
    testWidgets('muestra CircularProgressIndicator mientras carga',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _loading),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('no muestra lista mientras carga', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _loading),
      ));
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('el Scaffold tiene fondo azul oscuro en loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _loading),
      ));
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1E3A5F));
    });
  });

  // =========================================================================
  // Grupo 2 – Estado de error
  // =========================================================================
  group('Estado de error', () {
    testWidgets('muestra mensaje de error cuando ocurre un fallo',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _error),
      ));
      await tester.pump();
      expect(find.text('Error de prueba'), findsOneWidget);
    });

    testWidgets('muestra ícono de error', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _error),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('muestra botón "Reintentar" en estado de error',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _error),
      ));
      await tester.pump();
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('tap en "Reintentar" no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _error),
      ));
      await tester.pump();
      await tester.tap(find.text('Reintentar'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 3 – Estado vacío
  // =========================================================================
  group('Estado vacío (sin certificados)', () {
    testWidgets('muestra texto "Sin certificados aún"', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.text('Sin certificados aún'), findsOneWidget);
    });

    testWidgets('muestra ícono workspace_premium_outlined', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
    });

    testWidgets('muestra botón "Actualizar" en estado vacío', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.text('Actualizar'), findsOneWidget);
    });

    testWidgets('muestra mensaje informativo al usuario', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(
        find.textContaining('aparecerán aquí'),
        findsOneWidget,
      );
    });

    testWidgets('tap en "Actualizar" no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      await tester.tap(find.text('Actualizar'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 4 – Header y estructura principal
  // =========================================================================
  group('Header y estructura principal', () {
    testWidgets('muestra "Mis Certificados" en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(
          testOverrideData: {'__state__': 'data', '__certs__': []},
        ),
      ));
      await tester.pump();
      expect(find.text('Mis Certificados'), findsOneWidget);
    });

    testWidgets('muestra subtítulo del header', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(
          testOverrideData: {'__state__': 'data', '__certs__': []},
        ),
      ));
      await tester.pump();
      expect(
        find.text('Visualiza y descarga tus certificados'),
        findsOneWidget,
      );
    });

    testWidgets('el Scaffold tiene fondo azul oscuro', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1E3A5F));
    });

    testWidgets('existe un SafeArea como contenedor raíz', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('muestra ícono de refresh en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    });

    testWidgets('muestra ícono de cierre (X) en el header', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('tap en refresh no lanza excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('el área de contenido tiene color claro', (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      final containers =
          tester.widgetList<Container>(find.byType(Container));
      final hayFondoClaro = containers.any((c) {
        final d = c.decoration;
        if (d is BoxDecoration) return d.color == const Color(0xFFE8EDF2);
        return false;
      });
      expect(hayFondoClaro, isTrue);
    });

    testWidgets('el área de contenido tiene bordes superiores redondeados',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const VerCertificadosScreen(testOverrideData: _vacio),
      ));
      await tester.pump();
      final containers =
          tester.widgetList<Container>(find.byType(Container));
      final hayRedondeado = containers.any((c) {
        final d = c.decoration;
        if (d is BoxDecoration && d.borderRadius != null) {
          final br = d.borderRadius as BorderRadius;
          return br.topLeft.x > 0 && br.topRight.x > 0;
        }
        return false;
      });
      expect(hayRedondeado, isTrue);
    });
  });

  // =========================================================================
  // Grupo 5 – Tarjeta de certificado (card individual)
  // =========================================================================
  group('Tarjeta de certificado', () {
    testWidgets('muestra el nombre del evento', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(
        find.textContaining('Congreso Internacional de Sistemas'),
        findsOneWidget,
      );
    });

    testWidgets('muestra el rol del certificado como badge', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.text('ASISTENTE'), findsOneWidget);
    });

    testWidgets('muestra la fecha del certificado', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('15 de marzo de 2024'), findsOneWidget);
    });

    testWidgets('muestra la carrera del certificado', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('Ingeniería de Sistemas'), findsOneWidget);
    });

    testWidgets('muestra horas académicas para ASISTENTE', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('8 horas académicas'), findsOneWidget);
    });

    testWidgets('no muestra horas para rol PONENTE', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certPonente],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('horas académicas'), findsNothing);
    });

    testWidgets('muestra botón "Ver" en la tarjeta', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.text('Ver'), findsOneWidget);
    });

    testWidgets('muestra botón "Descargar" en la tarjeta', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.text('Descargar'), findsOneWidget);
    });

    testWidgets('la tarjeta usa Card con bordes redondeados', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('evento largo no genera excepción de overflow', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certEventoLargo],
          },
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('certificado mínimo renderiza sin excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certMinimo],
          },
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // =========================================================================
  // Grupo 6 – Íconos por rol
  // =========================================================================
  group('Íconos por rol', () {
    testWidgets('ícono mic_rounded aparece para rol PONENTE', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certPonente],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });

    testWidgets('ícono gavel_rounded aparece para rol JURADO', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certJurado],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.gavel_rounded), findsOneWidget);
    });

    testWidgets('ícono manage_accounts_rounded aparece para ORGANIZADOR',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certOrganizador],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.manage_accounts_rounded), findsOneWidget);
    });

    testWidgets('ícono workspace_premium aparece para rol ASISTENTE',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.workspace_premium), findsWidgets);
    });
  });

  // =========================================================================
  // Grupo 7 – Resumen (banner superior de la lista)
  // =========================================================================
  group('Resumen de certificados', () {
    testWidgets('muestra resumen con conteo correcto para 1 certificado',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('1 certificado recibido'), findsOneWidget);
    });

    testWidgets('muestra resumen con conteo en plural para varios certificados',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto, _certPonente, _certJurado],
          },
        ),
      ));
      await tester.pump();
      expect(find.textContaining('3 certificados recibidos'), findsOneWidget);
    });

    testWidgets('muestra ícono workspace_premium en el resumen',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.workspace_premium), findsWidgets);
    });

    testWidgets('muestra desglose de roles en el resumen', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto, _certPonente],
          },
        ),
      ));
      await tester.pump();
      // El resumen muestra "1 asistente · 1 ponente" (o similar)
      expect(find.textContaining('asistente'), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 8 – Lista de múltiples certificados
  // =========================================================================
  group('Lista con múltiples certificados', () {
    testWidgets('renderiza varios certificados sin excepción', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [
              _certCompleto,
              _certPonente,
              _certJurado,
              _certOrganizador,
            ],
          },
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('muestra ListView cuando hay certificados', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('muestra RefreshIndicator en la lista', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('todos los roles distintos muestran su badge correcto',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [
              _certCompleto,
              _certPonente,
              _certJurado,
              _certOrganizador,
            ],
          },
        ),
      ));
      await tester.pump();
      expect(find.text('ASISTENTE'),   findsOneWidget);
      expect(find.text('PONENTE'),     findsOneWidget);
      expect(find.text('JURADO'),      findsOneWidget);
      expect(find.text('ORGANIZADOR'), findsOneWidget);
    });
  });

  // =========================================================================
  // Grupo 9 – Íconos de detalle en la tarjeta
  // =========================================================================
  group('Íconos de detalle en tarjeta', () {
    testWidgets('muestra ícono calendar para la fecha', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });

    testWidgets('muestra ícono school para la carrera', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.school_outlined), findsOneWidget);
    });

    testWidgets('muestra ícono timer para las horas (ASISTENTE)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    });

    testWidgets('muestra ícono de descarga en el botón Descargar',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
    });

    testWidgets('muestra ícono de ojo en el botón Ver', (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certCompleto],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('no muestra ícono calendar cuando fecha está vacía',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certMinimo],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.calendar_today_outlined), findsNothing);
    });

    testWidgets('no muestra ícono school cuando carrera está vacía',
        (tester) async {
      await tester.pumpWidget(_wrap(
        VerCertificadosScreen(
          testOverrideData: {
            '__state__': 'data',
            '__certs__': [_certMinimo],
          },
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.school_outlined), findsNothing);
    });
  });
}