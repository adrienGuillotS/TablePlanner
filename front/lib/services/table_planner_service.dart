import 'dart:math';
import '../models/person.dart';

class TableResult {
  final List<Person> table1;
  final List<Person> table2;

  TableResult(this.table1, this.table2);
}

class TablePlannerService {
  bool canSeat(Person person, List<Person> table) {
    if (table.isEmpty) {
      return true;
    }
    var lastPerson = table.last;
    if (person.gender == lastPerson.gender) {
      print("Cannot seat ${person.name} because of gender constraint with ${lastPerson.name}");
      return false;
    }
    if (person.family == lastPerson.family) {
      print("Cannot seat ${person.name} because they are from the same family as ${lastPerson.name}");
      return false;
    }
    return true;
  }

  TableResult generateTablePlan(
    List<Person> attendees,
    TableSizes tableSizes,
  ) {
    var shuffledAttendees = List<Person>.from(attendees)..shuffle(Random());

    var table1 = <Person>[];
    var table2 = <Person>[];
    var seated = <Person>{};

    final table1Size = tableSizes.table1Size;
    final table2Size = tableSizes.table2Size;

    // Fill Table 1 completely before starting Table 2
    for (var person in shuffledAttendees) {
      print("Current Person: ${person.name}");
      
      if (table1.length < table1Size) {
        // Try seating at Table 1
        if (!seated.contains(person) && canSeat(person, table1)) {
          print("Can seat ${person.name} at Table 1");
          table1.add(person);
          seated.add(person);
        } else {
          // Try to seat the next available person if this one cannot be seated
          bool seatedNext = false;
          for (var nextPerson in shuffledAttendees) {
            print("Next Person: ${nextPerson.name}");
            if (!seated.contains(nextPerson) && canSeat(nextPerson, table1)) {
              print("${nextPerson.name} can seat at Table 1");
              table1.add(nextPerson);
              seated.add(nextPerson);
              seatedNext = true;
              break; // Proceed to next person after seating
            }
          }
          
          // If no suitable next person is found, force seat the current person
          if (!seatedNext && !seated.contains(person)) {
            table1.add(person);
            seated.add(person);
            print("Forcing seat for ${person.name} at Table 1");
          }
        }
        print("Current Table 1: ${table1.map((p) => p.name).toList()}");
        print("Seated Attendees: ${seated.map((p) => p.name).toList()}");
        print("-" * 50);
      } else if (table2.length < table2Size) {
        if (!seated.contains(person) && canSeat(person, table2)) {
          print("Can seat ${person.name} at Table 2");
          table2.add(person);
          seated.add(person);
        } else {
          // Try to seat the next available person at Table 2
          bool seatedNext = false;
          for (var nextPerson in shuffledAttendees) {
            print("Next Person: ${nextPerson.name}");
            if (!seated.contains(nextPerson) && canSeat(nextPerson, table2)) {
              print("${nextPerson.name} can seat at Table 2");
              table2.add(nextPerson);
              seated.add(nextPerson);
              seatedNext = true;
              break;
            }
          }

          if (!seatedNext && !seated.contains(person)) {
            print("Forcing seat for ${person.name} at Table 2");
            table2.add(person);
            seated.add(person);
          }
        }
        print("Current Table 2: ${table2.map((p) => p.name).toList()}");
        print("Seated Attendees: ${seated.map((p) => p.name).toList()}");
        print("-" * 50);
      }
    }

    // Force-seat any remaining attendees
    for (var person in shuffledAttendees) {
      if (!seated.contains(person)) {
        if (table1.length < table1Size) {
          table1.add(person);
          seated.add(person);
        } else if (table2.length < table2Size) {
          table2.add(person);
          seated.add(person);
        }
      }
    }

    // Ensure Polo is seated at the second-last position in Table 1
    var poloIndex = table1.indexWhere((p) => p.name == "Polo");
    if (poloIndex != -1 && poloIndex != table1.length - 2) {
      var polo = table1.removeAt(poloIndex);
      table1.insert(table1.length - 1, polo);
    }

    return TableResult(table1, table2);
  }
}

class TableSizes {
  final int table1Size;
  final int table2Size;

  const TableSizes(this.table1Size, this.table2Size);
}