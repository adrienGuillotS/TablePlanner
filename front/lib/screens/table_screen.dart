import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:math';

class TableScreen extends StatefulWidget {
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<Map<String, dynamic>> table1 = [];
  List<Map<String, dynamic>> table2 = [];
  List<Map<String, dynamic>> peopleList = [];
  List<Map<String, dynamic>> invitedPeople = []; // To store invited guests
  Map<String, bool> presence = {};

  String statusMessage = "Appuyez sur le bouton pour générer un plan.";

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  void fetchPeople() async {
    try {
      final people = await ApiService.getPeople();
      setState(() {
        peopleList = people;
        for (var person in people) {
          presence[person['name']] = true;
        }
      });
    } catch (e) {
      setState(() {
        statusMessage = "Erreur lors de la récupération des personnes.";
      });
    }
  }

  void generateTablePlan() async {
    setState(() {
      statusMessage = "Chargement en cours...";
    });

    try {
      final presentPeople = peopleList
          .where((person) => presence[person['name']] == true)
          .toList();

      // Include invited people in the table plan
      final allPeople = presentPeople + invitedPeople;

      final plan = await ApiService.getTablePlan(allPeople);
      setState(() {
        table1 = plan['table1'];
        table2 = plan['table2'];

        // Check if Polo is in table2 and move them to table1 if needed
        final poloIndexInTable2 = table2.indexWhere((person) => person['name'] == 'Polo');
        if (poloIndexInTable2 != -1) {
          final polo = table2.removeAt(poloIndexInTable2);  // Remove Polo from table2
          table1.add(polo);  // Add Polo to table1
        }

        statusMessage = "Plan de table généré avec succès mamounette chérie.";
      });
    } catch (e) {
      setState(() {
        statusMessage = "Erreur : Impossible de générer le plan mamoune appelle adrien et oscar.";
      });
    }
  }

  // Method to add an invité
  void addInvite(String name, String family, String gender) {
    setState(() {
      invitedPeople.add({'name': name, 'family': family, 'gender': gender});
      peopleList.add({'name': name, 'family': family, 'gender': gender});
    });
  }

  Widget buildRectangleTable(List<Map<String, dynamic>> table) {
    if (table.length < 6) {
      return Container(
        child: Center(child: Text('Minimum 6 people required')),
      );
    }

    // Find Polo and create modified table
    List<Map<String, dynamic>> modifiedTable = List.from(table);
    int? poloIndex;
    for (int i = 0; i < modifiedTable.length; i++) {
      if (modifiedTable[i]['name'] == 'Polo') {
        poloIndex = i;
        break;
      }
    }

    // Calculate distribution
    final sideCount = 2;
    final remainingCount = modifiedTable.length - (sideCount * 2);
    final lengthCount = remainingCount ~/ 2;

    List<Map<String, dynamic>> top = [];
    List<Map<String, dynamic>> right = [];
    List<Map<String, dynamic>> bottom = [];
    List<Map<String, dynamic>> left = [];

    if (poloIndex != null) {
      // Remove Polo and reorganize
      final polo = modifiedTable.removeAt(poloIndex);
      
      // Distribute remaining people
      top = modifiedTable.sublist(0, lengthCount);
      right = modifiedTable.sublist(lengthCount, lengthCount + sideCount);
      bottom = modifiedTable.sublist(lengthCount + sideCount, lengthCount + sideCount + lengthCount);
      
      // Create left side with Polo second from bottom
      if (modifiedTable.isNotEmpty) {
        left = [modifiedTable.last, polo];
      } else {
        left = [polo];
      }
    } else {
      // Normal distribution without Polo
      top = modifiedTable.sublist(0, lengthCount);
      right = modifiedTable.sublist(lengthCount, lengthCount + sideCount);
      bottom = modifiedTable.sublist(lengthCount + sideCount, lengthCount + sideCount + lengthCount);
      left = modifiedTable.sublist(modifiedTable.length - sideCount);
    }

    final TextStyle nameStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade800,
    );

    return Container(
      width: 600,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top names
          Positioned(
            top: 8,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: top.map((person) => Text(person['name']!, style: nameStyle)).toList(),
            ),
          ),
          // Right names (2 people)
          Positioned(
            top: 70,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: right.map((person) => Text(person['name']!, style: nameStyle)).toList(),
            ),
          ),
          // Bottom names
          Positioned(
            bottom: 8,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: bottom.reversed.map((person) => Text(person['name']!, style: nameStyle)).toList(),
            ),
          ),
          // Left names (2 people)
          Positioned(
            top: 70,
            left: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: left.map((person) => Text(person['name']!, style: nameStyle)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCircularTable(List<Map<String, dynamic>> table) {
    final TextStyle nameStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontFamily: 'SF Pro',
    );

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Table circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          // Names around circle
          ...table.asMap().entries.map((entry) {
            final index = entry.key;
            final person = entry.value['name'];
            final angle = (2 * pi * index) / table.length;
            
            // Radius for name placement
            final radius = 120.0;
            final x = cos(angle) * radius;
            final y = sin(angle) * radius;

            // Calculate text offset based on angle
            final textOffsetX = x > 0 ? -20.0 : x < 0 ? -40.0 : -30.0;
            final textOffsetY = y > 0 ? -10.0 : y < 0 ? -10.0 : -10.0;

            return Positioned(
              left: 150 + x + textOffsetX,
              top: 150 + y + textOffsetY,
              child: Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  person!,
                  style: nameStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group people by familyName
    final Map<String, List<Map<String, dynamic>>> families = {};

    for (var person in peopleList) {
      final familyName = person['family'] ?? 'Unknown';
      if (!families.containsKey(familyName)) {
        families[familyName] = [];
      }
      families[familyName]?.add(person);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Merci Mamounette", style: TextStyle(fontFamily: 'SF Pro')),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Split the screen into two columns using Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Left column: People buttons
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,  // Align to the left
                        children: [
                          for (var family in families.entries)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,  // Align family name and buttons to the left
                              children: [
                                // Display the family name
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    family.key,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                // Display each person as a button, aligned to the left
                                Wrap(
                                  alignment: WrapAlignment.start,  // Align buttons to the left
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: family.value.map((person) {
                                    final isPresent = presence[person['name']] ?? true;
                                    return ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          presence[person['name']] = !(presence[person['name']] ?? true);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isPresent ? Colors.greenAccent : Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      child: Text(
                                        person['name'],
                                        style: const TextStyle(fontSize: 14, fontFamily: 'SF Pro', color: Colors.white),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Right column: Generated tables and "Generate Table" button
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // "Generate Table" button at the top right
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: generateTablePlan,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                "Générer le plan de table",
                                style: TextStyle(fontFamily: 'SF Pro'),
                              ),
                            ),
                          ),
                          
                          // Display tables (either rectangular or circular)
                          if (table1.isNotEmpty) buildRectangleTable(table1),
                          const SizedBox(height: 20),
                          if (table2.isNotEmpty) buildCircularTable(table2),

                          // Invite button at the bottom of the right column
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Show dialog to add invite
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String name = '';
                                    String family = '';
                                    String gender = '';
                                    
                                    return AlertDialog(
                                      title: Text("Ajouter un invité"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            onChanged: (value) => name = value,
                                            decoration: InputDecoration(hintText: "Nom de l'invité"),
                                          ),
                                          TextField(
                                            onChanged: (value) => family = value,
                                            decoration: InputDecoration(hintText: "Nom de famille"),
                                          ),
                                          TextField(
                                            onChanged: (value) => gender = value,
                                            decoration: InputDecoration(hintText: "Sexe"),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Annuler"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            addInvite(name, family, gender);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ajouter l'invité"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                backgroundColor: Colors.greenAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                "+ Ajouter un invité",
                                style: TextStyle(fontFamily: 'SF Pro'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Display the status message at the bottom of the screen
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'SF Pro', color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
