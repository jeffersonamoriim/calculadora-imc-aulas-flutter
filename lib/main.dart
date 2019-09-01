import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Person{
  double weight, height;
  int gender;

  Person({this.weight, this.height, this.gender});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _result;
  double _imc = 0;
  int _selectedRadio;

  @override
  void initState() {
    super.initState();
    resetFields();
    _selectedRadio = 0;
  }

  void _setSelectRadio(int value){
    setState(() {
     _selectedRadio = value; 
    });
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }


  Widget _buildRadioButtom(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Masculino",
        style: new TextStyle(
          fontSize: 15.0,
        )),
        new Radio(
          value: 1,
          groupValue: _selectedRadio,
          onChanged: (value) {
            print("Radio $value");
            _setSelectRadio(value);
          },
        ),
        new Text("Feminino",
        style: new TextStyle(
          fontSize: 15.0,
        )),
        new Radio(
          value: 2,
          groupValue: _selectedRadio,
          onChanged: (value) {
            print("Radio $value");
            _setSelectRadio(value);
          },
        ),
      ],
    );
  }

  Form buildForm() {
    return  
    Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso (kg)",
              error: "Insira seu peso!",
              controller: _weightController),
          buildTextFormField(
              label: "Altura (cm)",
              error: "Insira uma altura!",
              controller: _heightController),
          _buildRadioButtom(),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  void calculateImc() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100.0;
    _imc = weight / (height * height);

    if (_selectedRadio == 1) {
      setState(() {
      _result = "IMC = ${_imc.toStringAsPrecision(3)}\n";
      if (_imc < 20.7)
        _result += "Abaixo do Peso";
      else if (_imc < 26.4)
        _result += "Peso ideal";
      else if (_imc < 27.8)
        _result += "Levemente acima do peso";
      else if (_imc < 31.1)
        _result += "Acima do Peso";
      else
        _result += "Obesidade";
    });
    }
    else if (_selectedRadio == 2){
      setState(() {
      _result = "IMC = ${_imc.toStringAsPrecision(3)}\n";
      if (_imc < 19.1)
      _result += "Abaixo do peso";
      else if (_imc < 25.8)
        _result += "Peso ideal";
      else if (_imc < 27.3)
        _result += "Levemente acima do peso";
      else if (_imc < 32.3)
        _result += "Acima do Peso";
      else
        _result += "Obesidade";
    });
    }
  }

  Widget buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            calculateImc();
          }
        },
        color: Colors.blueAccent,
        child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildTextResult() {
    if (_selectedRadio == 1){
    if (_imc < 20.7)
    return buildPaddingColors(Colors.orange);
    else if (_imc < 26.4)
    return buildPaddingColors(Colors.green);
    else if (_imc < 27.8)
    return buildPaddingColors(Colors.yellow[900]);
    else if (_imc < 31.1)
    return buildPaddingColors(Colors.orange[900]);
    else
    return buildPaddingColors(Colors.redAccent[700]);
    }
    else if (_selectedRadio == 2){
    if (_imc < 19.1)
    return buildPaddingColors(Colors.orange);
    else if (_imc < 25.8)
    return buildPaddingColors(Colors.green);
    else if (_imc < 27.3)
    return buildPaddingColors(Colors.yellow[900]);
    else if (_imc < 32.3)
    return buildPaddingColors(Colors.orange[900]);
    else
    return buildPaddingColors(Colors.redAccent[700]);
    }
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }

  Widget buildPaddingColors(Color color) {
    return Padding(
    padding: EdgeInsets.symmetric(vertical: 36.0),
    child: Text(
      _result,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: 22.0,
        fontWeight: FontWeight.bold, ),
    ),
  );
  }
}