import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'dart:html' as html;  // Importar para la descarga de archivos en Web

class SupervisionScreen extends StatefulWidget {
  @override
  _SupervisionScreenState createState() => _SupervisionScreenState();
}

class _SupervisionScreenState extends State<SupervisionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool?> respuestas = {};
  final SignatureController _signatureControllerSupervisor = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  final SignatureController _signatureControllerDueno = SignatureController(penStrokeWidth: 5, penColor: Colors.black);

  // Controladores de los campos del formulario
  final TextEditingController _fechaVisitaController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaTerminoController = TextEditingController();
  final TextEditingController _registroHidrocarburosController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _productosAutorizadosController = TextEditingController();
  final TextEditingController _numeroSurtDispController = TextEditingController();
  final TextEditingController _numeroTotalProductosController = TextEditingController();
  final TextEditingController _fiscalizadorOsinergminController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Supervisión', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 17, 70, 146),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('ACTA DE FISCALIZACIÓN DE CONTROL DE REGISTRO DE INVENTARIO DE COMBUSTIBLES'),
                _buildTextField(_fechaVisitaController, 'Fecha de visita'),
                _buildTextField(_horaInicioController, 'Hora de inicio'),
                _buildTextField(_horaTerminoController, 'Hora de término'),
                _buildTextField(_registroHidrocarburosController, 'Registro de hidrocarburos Nº'),
                _buildTextField(_rucController, 'RUC'),
                _buildTextField(_direccionController, 'Dirección'),
                _buildTextField(_distritoController, 'Distrito'),
                _buildTextField(_provinciaController, 'Provincia'),
                _buildTextField(_departamentoController, 'Departamento'),
                _buildTextField(_productosAutorizadosController, 'Productos autorizados'),
                _buildTextField(_numeroSurtDispController, 'Nº surt-DISP / Nº PROD'),
                _buildTextField(_numeroTotalProductosController, 'Nº total productos'),
                _buildTextField(_fiscalizadorOsinergminController, 'Fiscalizador de Osinergmin'),
                SizedBox(height: 20),
                _buildSectionTitle('Conformidad del Registro de Inventario de Combustibles Líquidos'),
                _buildRadioButtonGroup('El establecimiento fiscalizado cuenta con RIC'),
                _buildRadioButtonGroup('El libro o cuaderno que contiene el RIC está foliado en cada hoja del representante o responsable autorizado'),
                _buildRadioButtonGroup('El libro o cuaderno que contiene el RIC está con firma en cada hoja del representante o responsable autorizado'),
                _buildRadioButtonGroup('La información contenida en el RIC se encuentra debidamente actualizada'),
                _buildRadioButtonGroup('El establecimiento fiscalizado cuenta con información RIC de los últimos 03 meses'),
                SizedBox(height: 20),
                _buildSectionTitle('II. OTROS'),
                _buildTextField(_fechaVisitaController, 'Otras ocurrencias detectadas en la fiscalización'),
                _buildTextField(_fechaVisitaController, 'Documentación recabada en la fiscalización'),
                _buildTextField(_fechaVisitaController, 'Manifestaciones u observaciones del Agente Fiscalizado'),
                _buildTextField(_fechaVisitaController, 'Negativa del Agente Fiscalizado o demás participantes a identificarse, suscribir o recibir el acta'),
                SizedBox(height: 20),

                // Firma del Supervisor
                _buildSectionTitle('Firma del Fiscalizador'),
                _buildSignatureArea(_signatureControllerSupervisor, 'Borrar Firma del Supervisor', 'Guardar Firma del Supervisor'),

                SizedBox(height: 20),
                // Firma del Dueño
                _buildSectionTitle('Firma del Dueño'),
                _buildSignatureArea(_signatureControllerDueno, 'Borrar Firma del Dueño', 'Guardar Firma del Dueño'),

                SizedBox(height: 20),
                Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      backgroundColor: Color.fromARGB(255, 17, 70, 146),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        // Mostrar el mensaje de que el formulario se está generando
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generando informe por la IA, espere', style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
        );

        // Retrasar la descarga 5 segundos
        await Future.delayed(Duration(seconds: 5));

        // Llamar a la función que genera el PDF
        await _generatePdf();

        // Mostrar mensaje de éxito después de la descarga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Formulario generado y listo para descargar', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
        );
      }
    },
    child: Text('Generar Informe IA', style: TextStyle(fontSize: 18, color: Colors.white)),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Widget _buildRadioButtonGroup(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: Text('Sí'),
                  value: true,
                  groupValue: respuestas[label],
                  onChanged: (bool? value) {
                    setState(() {
                      respuestas[label] = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: Text('No'),
                  value: false,
                  groupValue: respuestas[label],
                  onChanged: (bool? value) {
                    setState(() {
                      respuestas[label] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 17, 70, 146)),
      ),
    );
  }

  Widget _buildSignatureArea(SignatureController controller, String borrarFirmaText, String guardarFirmaText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Signature(
          controller: controller,
          height: 150,
          backgroundColor: Colors.grey[200]!,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  controller.clear();
                });
              },
              child: Text(borrarFirmaText, style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 17, 70, 146)),
            ),
            ElevatedButton(
              onPressed: () async {
                final Uint8List? signatureBytes = await controller.toPngBytes();
                if (signatureBytes != null) {
                  print('Firma guardada como imagen');
                }
              },
              child: Text(guardarFirmaText, style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 17, 70, 146)),
            ),
          ],
        ),
      ],
    );
  }

  // Función para generar el PDF
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final supervisorSignatureBytes = await _signatureControllerSupervisor.toPngBytes();
    final duenoSignatureBytes = await _signatureControllerDueno.toPngBytes();

    // Obtener los datos del formulario
    final fechaVisita = _fechaVisitaController.text;
    final horaInicio = _horaInicioController.text;
    final horaTermino = _horaTerminoController.text;
    final registroHidrocarburos = _registroHidrocarburosController.text;
    final ruc = _rucController.text;
    final direccion = _direccionController.text;
    final distrito = _distritoController.text;
    final provincia = _provinciaController.text;
    final departamento = _departamentoController.text;
    final productosAutorizados = _productosAutorizadosController.text;
    final numeroSurtDisp = _numeroSurtDispController.text;
    final numeroTotalProductos = _numeroTotalProductosController.text;
    final fiscalizadorOsinergmin = _fiscalizadorOsinergminController.text;

    // Obtener las respuestas de los radio buttons
    final respuesta1 = respuestas['El establecimiento fiscalizado cuenta con RIC'] == true ? 'Sí' : 'No';
    final respuesta2 = respuestas['El libro o cuaderno que contiene el RIC está foliado en cada hoja del representante o responsable autorizado'] == true ? 'Sí' : 'No';
    final respuesta3 = respuestas['El libro o cuaderno que contiene el RIC está con firma en cada hoja del representante o responsable autorizado'] == true ? 'Sí' : 'No';
    final respuesta4 = respuestas['La información contenida en el RIC se encuentra debidamente actualizada'] == true ? 'Sí' : 'No';
    final respuesta5 = respuestas['El establecimiento fiscalizado cuenta con información RIC de los últimos 03 meses'] == true ? 'Sí' : 'No';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Formulario de Supervisión', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Fecha de Visita: $fechaVisita'),
              pw.Text('Hora de Inicio: $horaInicio'),
              pw.Text('Hora de Término: $horaTermino'),
              pw.Text('Registro de Hidrocarburos Nº: $registroHidrocarburos'),
              pw.Text('RUC: $ruc'),
              pw.Text('Dirección: $direccion'),
              pw.Text('Distrito: $distrito'),
              pw.Text('Provincia: $provincia'),
              pw.Text('Departamento: $departamento'),
              pw.Text('Productos Autorizados: $productosAutorizados'),
              pw.Text('Nº Surt-DISP / Nº PROD: $numeroSurtDisp'),
              pw.Text('Nº Total Productos: $numeroTotalProductos'),
              pw.Text('Fiscalizador de Osinergmin: $fiscalizadorOsinergmin'),
              pw.SizedBox(height: 20),
              pw.Text('Conformidad del Registro de Inventario de Combustibles Líquidos'),
              pw.Text('El establecimiento fiscalizado cuenta con RIC: $respuesta1'),
              pw.Text('El libro o cuaderno que contiene el RIC está foliado en cada hoja: $respuesta2'),
              pw.Text('El libro o cuaderno que contiene el RIC está con firma en cada hoja: $respuesta3'),
              pw.Text('La información contenida en el RIC se encuentra debidamente actualizada: $respuesta4'),
              pw.Text('El establecimiento fiscalizado cuenta con información RIC de los últimos 03 meses: $respuesta5'),
              pw.SizedBox(height: 20),
              pw.Text('Firma del Fiscalizador:'),
              if (supervisorSignatureBytes != null)
                pw.Image(pw.MemoryImage(supervisorSignatureBytes), width: 200, height: 50),
              pw.SizedBox(height: 20),
              pw.Text('Firma del Dueño:'),
              if (duenoSignatureBytes != null)
                pw.Image(pw.MemoryImage(duenoSignatureBytes), width: 200, height: 50),
            ],
          );
        },
      ),
    );

    final output = await pdf.save();

    // Crear un Blob de los datos PDF para la descarga en Flutter Web
    final blob = html.Blob([output]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear un enlace de descarga y simular un clic para descargar el PDF
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'supervision_form.pdf';
    anchor.click();

    // Limpiar el objeto URL para liberar recursos
    html.Url.revokeObjectUrl(url);

    print('PDF generado y listo para descargar');
  }
}

