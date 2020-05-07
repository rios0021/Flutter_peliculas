
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:peliculas/src/models/personas_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class ActorDetallePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: _crearAppbar(actor),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height: 40.0,),
            Center(
              child: Hero(
                tag: actor.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    image: NetworkImage(actor.getPhoto()),
                    placeholder: AssetImage("assets/img/no-image.jpg"),
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            _crearInfoPersona(actor),
          ],
        ),
      ),
      // body: ScrollView(
      //   slivers: <Widget>[
      //     _crearAppbar(actor),
      //   ],
      // ),
    );
  }

  _crearAppbar(Actor actor) {
      
    return GradientAppBar(
      title: Text(
        actor.name,
        style: TextStyle(fontSize: 20.0),
      ),
      backgroundColorStart:_checkGender(actor.gender) == 'Male' ? Colors.green : Colors.lightBlueAccent,
      backgroundColorEnd: _checkGender(actor.gender) == 'Male' ? Colors.yellow : Colors.purple,
    );

    // return SliverAppBar(
    //     elevation: 3.0,
    //     backgroundColor: Colors.lime,
    //     expandedHeight: 100.0,
    //     floating: true,
    //     pinned: true,
    //     flexibleSpace: FlexibleSpaceBar(
    //       centerTitle: true,
    //       title: Text(
    //         actor.name,
    //         style: TextStyle(
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _crearInfoPersona(Actor actor) {
    final peliProvider = new PeliculasProvider();
    return FutureBuilder<Persona>(
      future: peliProvider.getPersona(actor.id),
      // initialData: Text('Loading...'),
      builder: (BuildContext context, AsyncSnapshot<Persona> snapshot) {
        if(snapshot.hasData){
          return _crearPersonaTextos(context, snapshot.data);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget _crearPersonaTextos(BuildContext context, Persona persona) {
    final _screenSize = MediaQuery.of(context).size;
    return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 130.0,),
              Icon(Icons.wc),
              SizedBox(width: 15.0,),
              Text(_checkGender(persona.gender), style: Theme.of(context).textTheme.subhead,)
            ],
            // mainAxisAlignment: MainAxisAlignment.center,
            ),
          Row(
            children: <Widget>[
              SizedBox(width: 130.0,),
              Icon(Icons.public),
              SizedBox(width: 15.0,),
              Container(
                width: _screenSize.width* .5,
                child: Text(persona.placeOfBirth, style: Theme.of(context).textTheme.subhead,))
            ],
            ),
          Row(children: <Widget>[
              SizedBox(width: 130.0,),
              Icon(Icons.calendar_today),
              SizedBox(width: 15.0,),
              Text(persona.birthday, style: Theme.of(context).textTheme.subhead,)
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Text(
              persona.biography,
              textAlign: TextAlign.justify,
            ),
          )
          
        ],

    );
  }

  String _checkGender(int gender) => gender==1?'Female':'Male';

}
