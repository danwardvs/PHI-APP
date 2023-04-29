import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventsPage extends StatelessWidget {
  // Holds the data for the incoming data request
  Future<String> futureEvents;

  Future<String> fetchEvents() async {
    try {
      final response = await http.get('https://adsgames.net/phi');

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        return response.body;
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        return "Failed to load event data.";
      }
    } catch (_) {
      return "Failed to load event data.";
    }
  }

  // Loads data on construction of the tab
  EventsPage() {
    futureEvents = fetchEvents();
  }

  ListView eventList(String data) {
    //Process full string into one string per line
    List<String> items = data.split("\n");
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // Create error message object
          if (data == "Failed to load event data.") {
            return Card(
              child: PhiEventError(context),
            );
            // If data is valid
          } else {
            // Split line on comma to seperate title from list
            List<String> split_event = item.split('|');

            // Handle forgotten date or title
            String title = "Default Title";
            String date = "Default Date";
            String details = "Default details";
            if (split_event.length > 2) details = split_event[2];
            if (split_event.length > 1) date = split_event[1];
            if (split_event.length > 0) title = split_event[0];

            // Create listview based on this data
            return Card(
              child: PhiEvent(title, date, details, context),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: futureEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Call function to generate list, supply data to it
          return eventList(snapshot.data);
        } else if (snapshot.hasError) {}
        return CircularProgressIndicator();
      },
    );
  }

  void refresh(context) {
    fetchEvents();
    build(context);
  }
}

class SecondRoute extends StatelessWidget {
  String title;
  String description;
  String date;
  SecondRoute(String new_title, String new_date, String new_description) {
    title = new_title;
    description = new_description;
    date = new_date;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details on " + title),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(description + "\n",
                style: TextStyle(color: Colors.grey[800], fontSize: 20)),
            Text(date,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

// Wrapper class to store details to listTile
class PhiEvent extends ListTile {
  PhiEvent(String title, String date, String details, context)
      : super(
          title: new Text(title),
          subtitle: new Text(date),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondRoute(title, date, details)),
          ),
        );
}

class PhiEventError extends ListTile {
  PhiEventError(context)
      : super(
          title: new Text("Failed to load event data."),
          subtitle: new Text("Check your network connection and try again."),
        );
}
