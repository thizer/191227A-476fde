import 'package:consumir_api/list_bloc.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListBloc _listBloc = ListBloc();

  @override
  void dispose() {
    _listBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _listBloc.output,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.data.length == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Nenhum registro'),
                      IconButton(
                        onPressed: () => _listBloc.getList(),
                        color: Colors.blue,
                        icon: Icon(Icons.refresh),
                      )
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _listBloc.getList(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      Map<String, dynamic> item = snapshot.data[i];

                      return ListTile(
                        leading: const Icon(Icons.people),
                        title: Text('#${item['id']} ${item['name']}'),
                        subtitle: Text('${item['desc']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.red[700],
                          onPressed: () => _listBloc.delete(item['id'].toString()),
                        ),
                        onLongPress: () async => _listBloc.update(item['id'].toString()),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _listBloc.create(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
