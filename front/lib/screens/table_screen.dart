import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../models/person.dart';
import '../services/table_planner_service.dart';
import '../providers/table_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final List<Person> initialPeople = [
  // Famille Chaufour
  Person(name: "Mamoune", gender: "Female", family: "Chaufour"),
  Person(name: "Polo", gender: "Male", family: "Chaufour"),
  // Famille ChaufourDablanc
  Person(name: "Suzie", gender: "Female", family: "ChaufourDablanc"),
  Person(name: "Oscar", gender: "Male", family: "ChaufourDablanc"),
  Person(name: "Juliette", gender: "Female", family: "ChaufourDablanc"),
  Person(name: "Romain", gender: "Male", family: "ChaufourDablanc"),
  
  // Famille Guillot
  Person(name: "JB", gender: "Male", family: "Guillot"),
  Person(name: "Séverine", gender: "Female", family: "Guillot"),
  Person(name: "Alix", gender: "Female", family: "Guillot"),
  Person(name: "Maxou", gender: "Male", family: "Guillot"),
  Person(name: "Sixtine", gender: "Female", family: "Guillot"),
  Person(name: "Adrien", gender: "Male", family: "Guillot"),
  
  // Famille Cubertafond
  Person(name: "Judith", gender: "Female", family: "Cubertafond"),
  Person(name: "MartinCub", gender: "Male", family: "Cubertafond"),
  Person(name: "Honorine", gender: "Female", family: "Cubertafond"),
  Person(name: "Dazz", gender: "Male", family: "Cubertafond"),
  Person(name: "Elise", gender: "Female", family: "Cubertafond"),
  
  // Famille Poulain
  Person(name: "Kieran", gender: "Male", family: "Poulain"),
  Person(name: "Marie", gender: "Female", family: "Poulain"),
  Person(name: "Melchior", gender: "Male", family: "Poulain"),
  Person(name: "Alma", gender: "Female", family: "Poulain"),
  Person(name: "Amaury", gender: "Male", family: "Poulain"),
  
  // Famille ChaufourHauret
  Person(name: "Martin", gender: "Male", family: "ChaufourHauret"),
  Person(name: "Carine", gender: "Female", family: "ChaufourHauret"),
  Person(name: "Ernest", gender: "Male", family: "ChaufourHauret"),
  Person(name: "Stan", gender: "Male", family: "ChaufourHauret"),
  Person(name: "Laure", gender: "Female", family: "ChaufourHauret"),
];

class TableScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  final _tablePlannerService = TablePlannerService();
  List<Person> peopleList = [];
  List<Person> invitedPeople = [];
  Map<String, bool> presence = {};
  String statusMessage = "Appuie sur le bouton pour générer un plan Mamoune.";

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String? savedPeopleJson = prefs.getString('people');
      final String? savedInvitedJson = prefs.getString('invited');
      
      if (savedPeopleJson != null) {
        final List<dynamic> decoded = jsonDecode(savedPeopleJson);
        setState(() {
          peopleList = decoded.map((json) => Person.fromJson(json)).toList();
        });
      } else {
        setState(() {
          peopleList = List.from(initialPeople);
        });
      }

      for (var person in peopleList) {
        presence[person.name] = true;
      }

      if (savedInvitedJson != null) {
        final List<dynamic> decoded = jsonDecode(savedInvitedJson);
        setState(() {
          invitedPeople = decoded.map((json) => Person.fromJson(json)).toList();
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Erreur lors du chargement des données: $e";
        peopleList = List.from(initialPeople);
        for (var person in peopleList) {
          presence[person.name] = true;
        }
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('people', jsonEncode(peopleList.map((p) => p.toJson()).toList()));
      await prefs.setString('invited', jsonEncode(invitedPeople.map((p) => p.toJson()).toList()));
    } catch (e) {
      setState(() {
        statusMessage = "Erreur lors de la sauvegarde: $e";
      });
    }
  }

  Future<void> addInvite(String name, String family, String gender) async {
    final newPerson = Person(
      name: name,
      family: family,
      gender: gender,
    );

    setState(() {
      invitedPeople.add(newPerson);
      peopleList.add(newPerson);
      presence[name] = true;
    });
    
    await _saveData();
  }

  void generateTablePlan() {
    setState(() {
      statusMessage = "Génération du plan...";
    });

    try {
      final presentPeople = peopleList
          .where((person) => presence[person.name] == true)
          .toList();

      final result = _tablePlannerService.generateTablePlan(
        presentPeople,
        TableSizes(20, 7),
      );

      ref.read(tablePlanProvider.notifier).state = result;
      
      setState(() {
        statusMessage = "Plan de table généré avec succès mamounette!";
      });
    } catch (e) {
      setState(() {
        statusMessage = "Erreur lors de la génération du plan. Mince appelle Adrien ou Oscar!";
      });
    }
  }

  Widget buildRectangleTable(List<Person> table) {
    if (table.length < 6) {
      return Container(
        child: Center(
          child: Text(
            'Minimum 6 personnes requises',
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ),
      );
    }

    List<Person> modifiedTable = List.from(table);
    int poloIndex = modifiedTable.indexWhere((p) => p.name == 'Polo');

    final sideCount = 2;
    final remainingCount = modifiedTable.length - (sideCount * 2);
    final lengthCount = remainingCount ~/ 2;

    List<Person> top = [];
    List<Person> right = [];
    List<Person> bottom = [];
    List<Person> left = [];

    if (poloIndex != -1) {
      final polo = modifiedTable.removeAt(poloIndex);
      top = modifiedTable.sublist(0, lengthCount);
      right = modifiedTable.sublist(lengthCount, lengthCount + sideCount);
      bottom = modifiedTable.sublist(lengthCount + sideCount, lengthCount + sideCount + lengthCount);
      if (modifiedTable.isNotEmpty) {
        left = [modifiedTable.last, polo];
      } else {
        left = [polo];
      }
    } else {
      top = modifiedTable.sublist(0, lengthCount);
      right = modifiedTable.sublist(lengthCount, lengthCount + sideCount);
      bottom = modifiedTable.sublist(lengthCount + sideCount, lengthCount + sideCount + lengthCount);
      left = modifiedTable.sublist(modifiedTable.length - sideCount);
    }

    final TextStyle nameStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 250,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border.all(color: CupertinoColors.systemGrey5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: top.map((person) => 
                Expanded(
                  child: Text(
                    person.name,
                    style: nameStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ).toList(),
            ),
          ),
          Positioned(
            top: 90,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: right.map((person) => 
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    person.name,
                    style: nameStyle,
                    textAlign: TextAlign.right,
                  ),
                )
              ).toList(),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: bottom.map((person) => 
                Expanded(
                  child: Text(
                    person.name,
                    style: nameStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ).toList(),
            ),
          ),
          Positioned(
            top: 90,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: left.map((person) => 
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    person.name,
                    style: nameStyle,
                    textAlign: TextAlign.left,
                  ),
                )
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRoundTable(List<Person> table) {
    if (table.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            'Pas de table ronde nécessaire',
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ),
      );
    }

    final TextStyle nameStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return Container(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                shape: BoxShape.circle,
                border: Border.all(color: CupertinoColors.systemGrey5),
              ),
            ),
          ),
          ...List.generate(table.length, (index) {
            final angle = (2 * pi * index) / table.length - (pi / 2);
            final radius = 100.0;
            final x = cos(angle) * radius;
            final y = sin(angle) * radius;
            
            return Positioned(
              left: 150 + x - 40,
              top: 150 + y - 10,
              child: Text(
                table[index].name,
                style: nameStyle,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFamilySection(String familyName, List<Person> familyMembers) {
    return CupertinoListSection.insetGrouped(
      header: Text(familyName),
      children: familyMembers.map((person) {
        final isInvited = invitedPeople.any((p) => p.name == person.name);
        return CupertinoListTile(
          title: Text(person.name),
          subtitle: Text(person.gender == 'Male' ? 'Homme' : 'Femme'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoSwitch(
                value: presence[person.name] ?? true,
                onChanged: (bool value) {
                  setState(() {
                    presence[person.name] = value;
                  });
                },
              ),
              if (isInvited)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onPressed: () async {
                    setState(() {
                      peopleList.removeWhere((p) => p.name == person.name);
                      invitedPeople.removeWhere((p) => p.name == person.name);
                      presence.remove(person.name);
                    });
                    await _saveData();
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInvitedList() {
    Map<String, List<Person>> families = {};
    List<Person> invited = [];

    for (var person in peopleList) {
      if (invitedPeople.any((p) => p.name == person.name)) {
        invited.add(person);
      } else {
        if (!families.containsKey(person.family)) {
          families[person.family] = [];
        }
        families[person.family]!.add(person);
      }
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'La Famille',
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(CupertinoIcons.person_add),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => AddInviteDialog(onAdd: addInvite),
                  );
                },
              ),
            ],
          ),
        ),
        ...families.entries.map((entry) => _buildFamilySection(entry.key, entry.value)).toList(),
        if (invited.isNotEmpty)
          _buildFamilySection('Invités', invited),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableResult = ref.watch(tablePlanProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Plan de Table'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  statusMessage,
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    color: CupertinoColors.systemGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Table Rectangulaire',
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Center(child: buildRectangleTable(tableResult.table1)),
                if (tableResult.table2.isNotEmpty) ...[
                  SizedBox(height: 40),
                  Text(
                    'Table Ronde (invités supplémentaires)',
                    style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Center(child: buildRoundTable(tableResult.table2)),
                ],
                SizedBox(height: 20),
                CupertinoButton.filled(
                  onPressed: generateTablePlan,
                  child: Text('Générer le Plan'),
                ),
                SizedBox(height: 20),
                _buildInvitedList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddInviteDialog extends StatefulWidget {
  final Function(String name, String family, String gender) onAdd;

  AddInviteDialog({required this.onAdd});

  @override
  _AddInviteDialogState createState() => _AddInviteDialogState();
}

class _AddInviteDialogState extends State<AddInviteDialog> {
  final _nameController = TextEditingController();
  final _familyController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Ajouter un invité'),
      content: Column(
        children: [
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'Nom',
            padding: EdgeInsets.all(8),
          ),
          SizedBox(height: 8),
          CupertinoTextField(
            controller: _familyController,
            placeholder: 'Famille',
            padding: EdgeInsets.all(8),
          ),
          SizedBox(height: 8),
          CupertinoSegmentedControl<String>(
            children: {
              'Male': Text('Homme'),
              'Female': Text('Femme'),
            },
            onValueChanged: (String value) {
              setState(() {
                _selectedGender = value;
              });
            },
            groupValue: _selectedGender,
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text('Annuler'),
        ),
        CupertinoDialogAction(
          onPressed: () {
            if (_nameController.text.isNotEmpty && _familyController.text.isNotEmpty) {
              widget.onAdd(_nameController.text, _familyController.text, _selectedGender);
              Navigator.pop(context);
            }
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _familyController.dispose();
    super.dispose();
  }
}