import '../../core/network/api_service.dart';

class TaskRepository {
  final api = ApiService().dio;

  Future<List<dynamic>> fetchTasks({
  String? status,
  String? search,
}) async {
    final res = await api.get('/tasks',
    queryParameters: {
      if (status != null) 'status': status,
      if (search != null && search.isNotEmpty) 'search': search,
    },);
    return res.data;
  }

  Future<void> createTask(String title) async {
    await api.post('/tasks', data: {'title': title});
  }

  Future<void> toggleTask(int id) async {
    await api.patch('/tasks/$id/toggle');
  }

  Future<void> updateTask(int id, String title) async {
    await api.patch(
      '/tasks/$id',
      data: {'title': title},
    );
  }
  Future<void> deleteTask(int id) async {
    await api.delete('/tasks/$id');
  }
}
