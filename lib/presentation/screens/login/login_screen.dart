import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_event.dart';
import 'package:testcrudbloc/presentation/bloc/auth/auth_state.dart';

import '../../../core/constants/app_constants.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../note/note_screen.dart';  // Asegúrate de importar NoteScreen
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Predefinir valores para facilitar pruebas
    _emailController.text = '';
    _passwordController.text = '';
    
    // Configurar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is AuthenticatedState) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoteScreen(user: state.user)),
          (route) => false,
        );
      }
    },

      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              // Fondo con degradado
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.85),
                        Theme.of(context).colorScheme.primary.withOpacity(0.65),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // Elemento decorativo
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  ),
                ),
              ),

              // Contenido principal con fade
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Logo
                        Icon(
                          Icons.note_alt_outlined,
                          size: 80,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 12),

                        // Nombre de la app
                        Text(
                          AppConstants.appName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Organiza tus ideas en un solo lugar',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                              ),
                        ),
                        const SizedBox(height: 50),

                        // Formulario
                        Card(
                          elevation: 10,
                          color: Colors.white.withOpacity(0.95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    'Iniciar Sesión',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Email
                                  CustomTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    hint: 'ejemplo@email.com',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su email';
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 16),

                                  // Contraseña
                                  CustomTextField(
                                    controller: _passwordController,
                                    label: 'Contraseña',
                                    hint: '••••••',
                                    icon: Icons.lock_outline,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingrese su contraseña';
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 24),

                                  // Botón de ingresar
                                  CustomButton(
                                    label: 'Ingresar',
                                    isLoading: state is AuthLoadingState,
                                    onPressed: _login,
                                  ),
                                  const SizedBox(height: 12),

                                  // Registro
                                  OutlinedButton.icon(
                                    onPressed: () => _showRegisterModal(context),
                                    icon: const Icon(Icons.person_add_alt),
                                    label: const Text('¿No tienes cuenta? Regístrate'),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showRegisterModal(BuildContext context) {
    final _registerEmailController = TextEditingController();
    final _registerPasswordController = TextEditingController();
    final _registerFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear cuenta'),
          content: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _registerEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _registerPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese una contraseña';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_registerFormKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    RegisterEvent(
                      email: _registerEmailController.text.trim(),
                      password: _registerPasswordController.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }
}
