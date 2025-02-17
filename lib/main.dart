import 'package:flutter/material.dart';
import 'main2.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  runApp(FacilitoApp());
}

class FacilitoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 17, 70, 146), Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  'APP FISGO',
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'supervisor@osinergmin.gob.pe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 17, 70, 146),                         
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '¿Aún no tienes una cuenta? Únete aquí',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  void _showGasStationInfo(BuildContext context, String name, String image, String ruc, String address, String risk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(image, height: 100),
              SizedBox(height: 10),
              Text("C.O: $ruc"),
              Text("Dirección: $address"),
              Text("Riesgo: $risk"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupervisionScreen()),
                      );
                    },
                    child: Text("Realizar Supervisión"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Regresar"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 70, 146),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Text('OSINERGMIN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/map_image.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 200,
            left: 100,
            child: ElevatedButton(
              onPressed: () {
                _showGasStationInfo(
                  context,
                  "Grifo: AVA",
                  "assets/grifo1.png",
                  "9873",
                  "Av. Principal 123",
                  "Alto",
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('S/ 15.50', style: TextStyle(color: Colors.black)),
            ),
          ),
          Positioned(
            top: 300,
            right: 80,
            child: ElevatedButton(
              onPressed: () {
                _showGasStationInfo(
                  context,
                  "Grifo 2",
                  "assets/grifo2.png",
                  "9876",
                  "Calle Secundaria 456",
                  "Bajo",
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('S/ 14.90', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Grifos'),
          BottomNavigationBarItem(icon: Icon(Icons.fireplace), label: 'Balón de Gas'),
          BottomNavigationBarItem(icon: Icon(Icons.electrical_services), label: 'Electricidad'),
          BottomNavigationBarItem(icon: Icon(Icons.nature_people), label: 'Gas Natural'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Trámites'),
        ],
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}




