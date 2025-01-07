import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/person.dart';
import '../services/table_planner_service.dart';

final tablePlannerServiceProvider = Provider((ref) => TablePlannerService());

final tablePlanProvider = StateNotifierProvider<TablePlanNotifier, TableResult>((ref) {
  return TablePlanNotifier(ref.watch(tablePlannerServiceProvider));
});

class TablePlanNotifier extends StateNotifier<TableResult> {
  final TablePlannerService _service;

  TablePlanNotifier(this._service) : super(TableResult([], []));

  void generatePlan(List<Person> attendees) {
    state = _service.generateTablePlan(attendees, TableSizes(20, 7));
  }
}