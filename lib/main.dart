import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------- THEME & PALETA ----------------------
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    primary: Colors.green.shade400,
    secondary: Colors.green.shade200,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
);

// ---------------------- APP ----------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTurismo App',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// ==================== HOME PAGE ====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  // NOTA: No marcamos const aquí para evitar errores por widgets con controladores internos
  final List<Widget> _pages = [
    LandingPage(),
    CatalogoPage(),
    ProfilePage(),
    ContactPage(),
  ];

  final List<String> _titles = [
    "Inicio",
    "Catálogo de Aves",
    "Perfil",
    "Contacto",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFDFF7EA), // pastel claro
          foregroundColor: const Color(0xFF1B5E20),
          title: Text(_titles[_currentIndex]),
          elevation: 0,
        ),
        body: Row(
          children: [
            if (isDesktop)
              NavigationRail(
                backgroundColor: const Color(0xFFF6FEF6),
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) => setState(() => _currentIndex = index),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.home), label: Text("Inicio")),
                  NavigationRailDestination(icon: Icon(Icons.filter_alt), label: Text("Catálogo")),
                  NavigationRailDestination(icon: Icon(Icons.person), label: Text("Perfil")),
                  NavigationRailDestination(icon: Icon(Icons.contact_mail), label: Text("Contacto")),
                ],
              ),
            Expanded(
              // AnimatedSwitcher para transición suave entre pestañas
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                transitionBuilder: (child, animation) {
                  final inAnim = Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(animation);
                  return FadeTransition(opacity: animation, child: SlideTransition(position: inAnim, child: child));
                },
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
        bottomNavigationBar: isDesktop
            ? null
            : BottomNavigationBar(
                backgroundColor: const Color(0xFFF6FEF6),
                currentIndex: _currentIndex,
                selectedItemColor: const Color(0xFF1B5E20),
                unselectedItemColor: Colors.grey,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
                  BottomNavigationBarItem(icon: Icon(Icons.filter_alt), label: "Catálogo"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
                  BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: "Contacto"),
                ],
              ),
      );
    });
  }
}

// ==================== LANDING PAGE ====================
class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isDesktop = constraints.maxWidth > 800;
      return SingleChildScrollView(
        child: Column(
          children: [
            // HERO: imagen de fondo + overlay pastel + botones con gradiente
            Stack(
              children: [
                // Imagen de fondo
                Container(
                  width: double.infinity,
                  height: isDesktop ? 420 : 260,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1501706362039-c6e80948d60d?auto=format&fit=crop&w=1200&q=80"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay degradado pastel
                Container(
                  width: double.infinity,
                  height: isDesktop ? 420 : 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Texto y botones
                Positioned(
                  bottom: isDesktop ? 48 : 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🌿 Bienvenido a EcoTurismo",
                        style: TextStyle(
                          fontSize: isDesktop ? 34 : 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: const [Shadow(blurRadius: 6, color: Colors.black45, offset: Offset(1.5, 1.5))],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Descubre aves exóticas y reservas naturales únicas.",
                        style: TextStyle(fontSize: isDesktop ? 16 : 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Botón Ver Catálogo (usa navegación sencilla)
                          GradientButton(
                            text: "Ver Catálogo",
                            gradient: const LinearGradient(colors: [Color(0xFF8EE3B1), Color(0xFF45B26B)]),
                            onTap: () {
                              // Cambia a la pestaña catálogo
                              final state = context.findAncestorStateOfType<_HomePageState>();
                              state?.setState(() => state._currentIndex = 1);
                            },
                          ),
                          const SizedBox(width: 12),
                          GradientButton(
                            text: "Reservas",
                            gradient: const LinearGradient(colors: [Color(0xFFF6E3D6), Color(0xFFFFCDA3)]),
                            onTap: () {
                              // Cambia a la pestaña contacto/reservas
                              final state = context.findAncestorStateOfType<_HomePageState>();
                              state?.setState(() => state._currentIndex = 3);
                            },
                            minWidth: 140,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            // Características con iconos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                alignment: WrapAlignment.center,
                children: [
                  _featureIcon(Icons.flutter_dash, "Flutter"),
                  _featureIcon(Icons.android, "Android"),
                  _featureIcon(Icons.apple, "iOS"),
                  _featureIcon(Icons.web, "Web"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Imagen adicional con borde redondeado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  "https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=1200&q=80",
                  height: isDesktop ? 300 : 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      );
    });
  }

  Widget _featureIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 26, backgroundColor: const Color(0xFFDFF7EA), child: Icon(icon, size: 28, color: const Color(0xFF1B5E20))),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}

// ---------------------- CUSTOM GRADIENT BUTTON ----------------------
class GradientButton extends StatefulWidget {
  final String text;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final double minWidth;
  const GradientButton({
    super.key,
    required this.text,
    required this.gradient,
    required this.onTap,
    this.minWidth = 160,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  double _scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.98),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: Container(
          constraints: BoxConstraints(minWidth: widget.minWidth),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Center(child: Text(widget.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}

// ==================== CATALOGO PAGE ====================
class CatalogoPage extends StatelessWidget {
  CatalogoPage({super.key});

  // lista de ejemplo (no const para evitar conflictos)
  final List<Map<String, String>> aves = [
    {"nombre": "Quetzal", "tipo": "Endémica", "foto": "https://upload.wikimedia.org/wikipedia/commons/1/18/Quetzal01.jpg"},
    {"nombre": "Colibrí", "tipo": "Migratoria", "foto": "https://upload.wikimedia.org/wikipedia/commons/1/1d/Colibri.jpg"},
    {"nombre": "Garza Blanca", "tipo": "Endémica", "foto": "https://upload.wikimedia.org/wikipedia/commons/7/7a/Garza.jpg"},
    // puedes ampliar la lista o cargar desde tu BD después
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 2;
      if (constraints.maxWidth > 1200) crossAxisCount = 4;
      else if (constraints.maxWidth > 800) crossAxisCount = 3;

      return Column(
        children: [
          // Buscador simple (por ahora solo UI)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6FEF6),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Buscar ave...",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemCount: aves.length,
              itemBuilder: (context, index) {
                final ave = aves[index];
                return _BirdCard(
                  name: ave['nombre'] ?? '',
                  type: ave['tipo'] ?? '',
                  imageUrl: ave['foto'] ?? '',
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// tarjeta individual con estilo neumorphism suave
class _BirdCard extends StatelessWidget {
  final String name;
  final String type;
  final String imageUrl;
  const _BirdCard({required this.name, required this.type, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // efecto visual al tocar (ripple + escala con AnimatedScale podría añadirse)
      onTap: () => _showBirdDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Color(0x11000000), blurRadius: 8, offset: Offset(0, 6)),
            BoxShadow(color: Color(0x04FFFFFF), blurRadius: 1, offset: Offset(-1, -1)),
          ],
        ),
        child: Column(
          children: [
            // Imagen con fallback y placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(height: 120, alignment: Alignment.center, child: const CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(height: 120, alignment: Alignment.center, child: const Icon(Icons.broken_image, size: 44)),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(type, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // diálogo con información (animación nativa del AlertDialog)
  void _showBirdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(imageUrl: imageUrl, height: 150, placeholder: (c, u) => const CircularProgressIndicator(), errorWidget: (c, u, e) => const Icon(Icons.broken_image)),
            const SizedBox(height: 12),
            Text("Tipo: $type"),
            const SizedBox(height: 6),
            const Text("Descripción: Ave hermosa de la región."),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar"))],
      ),
    );
  }
}

// ==================== PROFILE PAGE ====================
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 56, backgroundImage: NetworkImage("https://images.unsplash.com/photo-1502767089025-6572583495b0?auto=format&fit=crop&w=500&q=80")),
          const SizedBox(height: 18),
          const Text("Configuración de Usuario", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Iniciar Sesión"),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage(), transitionsBuilder: (ctx, anim, sec, child) {
                return FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(anim), child: child));
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text("Registro de Guía"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage()));
            },
          ),
        ],
      ),
    );
  }
}

// ==================== CONTACT PAGE ====================
class ContactPage extends StatelessWidget {
  ContactPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text("Contáctanos", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              // Formulario simple (UI)
              TextField(decoration: InputDecoration(labelText: "Nombre", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 12),
              TextField(maxLines: 4, decoration: InputDecoration(labelText: "Mensaje", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: "Enviar",
                  gradient: const LinearGradient(colors: [Color(0xFF8EE3B1), Color(0xFF45B26B)]),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mensaje enviado"))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== LOGIN PAGE (MEJORADA) ====================
class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FEF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF7EA),
        foregroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), // fuerza volver al Home
        ),
        title: const Text("Volver"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(22),
            width: MediaQuery.of(context).size.width > 560 ? 480 : double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 8))],
            ),
            child: Column(
              children: [
                Hero(tag: 'login_lock', child: Icon(Icons.lock_outline, size: 84, color: const Color(0xFF1B5E20))),
                const SizedBox(height: 14),
                const Text("Iniciar Sesión", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.email), labelText: "Correo", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
                const SizedBox(height: 12),
                // Password con ver/ocultar
                TextField(
                  controller: passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Contraseña",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure)),
                  ),
                ),
                const SizedBox(height: 18),
                GradientButton(
                  text: "Iniciar Sesión",
                  gradient: const LinearGradient(colors: [Color(0xFF8EE3B1), Color(0xFF45B26B)]),
                  onTap: () {
                    // Aquí enlazarás con tu backend cuando toque
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login ejecutado (simulado)")));
                    // cerrar y volver a Home:
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  minWidth: double.infinity,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => RegisterPage(), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child))),
                  child: const Text("¿No tienes cuenta? Regístrate", style: TextStyle(color: Color(0xFF1B5E20))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== REGISTER PAGE (MEJORADA) ====================
class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FEF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF7EA),
        foregroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: const Text("Volver"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(22),
            width: MediaQuery.of(context).size.width > 560 ? 480 : double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 8))],
            ),
            child: Column(
              children: [
                Hero(tag: 'register_avatar', child: Icon(Icons.person_add_alt_1, size: 84, color: const Color(0xFF1B5E20))),
                const SizedBox(height: 12),
                const Text("Crea tu cuenta", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(controller: nameController, decoration: InputDecoration(prefixIcon: const Icon(Icons.person), labelText: "Nombre completo", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
                const SizedBox(height: 12),
                TextField(controller: emailController, decoration: InputDecoration(prefixIcon: const Icon(Icons.email), labelText: "Correo", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
                const SizedBox(height: 12),
                TextField(controller: passController, obscureText: _obscure, decoration: InputDecoration(prefixIcon: const Icon(Icons.lock), labelText: "Contraseña", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscure = !_obscure)))),
                const SizedBox(height: 18),
                GradientButton(
                  text: "Registrar",
                  gradient: const LinearGradient(colors: [Color(0xFFF6E3D6), Color(0xFFFFCDA3)]),
                  onTap: () {
                    // simular registro
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registro ejecutado (simulado)")));
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  minWidth: double.infinity,
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("¿Ya tienes cuenta? Inicia Sesión", style: TextStyle(color: Color(0xFF1B5E20)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
