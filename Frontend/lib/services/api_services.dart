import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://103.47.74.66:8000";


  // Helper: make GET request with Supabase headers
  static Future<http.Response> _get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'apikey': supabaseKey,
          'Authorization': 'Bearer $supabaseKey',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));
      return response;
    } on TimeoutException {
      throw Exception("Request to $url timed out. Please try again.");
    } catch (e) {
      throw Exception("Failed request to $url: $e");
    }
  }

  // -------------------------------
  // Districts & Blocks
  // -------------------------------

  // Get all districts
  static Future<List<String>> getDistricts() async {
    final response = await _get("$baseUrl/groundwater?select=district");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final Set<String> districts = {};
      for (var item in data) {
        if (item['district'] != null) {
          districts.add(item['district'].toString());
        }
      }
      return districts.toList()..sort();
    }
    throw Exception("Failed to load districts");
  }

  // Get all blocks for a district
  static Future<List<String>> getBlocks(String district) async {
    final response = await _get("$baseUrl/groundwater?select=block&district=ilike.$district");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final Set<String> blocks = {};
      for (var item in data) {
        if (item['block'] != null) {
          blocks.add(item['block'].toString());
        }
      }
      return blocks.toList()..sort();
    }
    throw Exception("Failed to load blocks for $district");
  }

  // Get district name if you only have block
  static Future<String?> getDistrictByBlock(String block) async {
    final response = await _get("$baseUrl/groundwater?select=district&block=ilike.$block&limit=1");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty && data[0]['district'] != null) {
        return data[0]['district'].toString();
      }
    }
    return null;
  }

  // Get all blocks with their district
  static Future<Map<String, String>> getAllBlocks() async {
    final response = await _get("$baseUrl/groundwater?select=block,district");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final Map<String, String> blockToDistrict = {};
      for (var item in data) {
        if (item['block'] != null && item['district'] != null) {
          blockToDistrict[item['block'].toString()] = item['district'].toString();
        }
      }
      return blockToDistrict;
    }
    throw Exception("Failed to load all blocks");
  }

  // -------------------------------
  // Analytics / Metrics
  // -------------------------------

  // Get plot data (simplified - returns raw data instead of base64 plot)
  static Future<List<Map<String, dynamic>>> getPlotData(String district, String block) async {
    final response = await _get("$baseUrl/groundwater?select=datetime_ts,water_level&district=ilike.$district&block=ilike.$block&order=datetime_ts.desc&limit=10");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Get plot of last 10 days mean levels (returns null since we need raw data now)
  static Future<String?> getPlotMeanLevels(String district, String block) async {
    // This method returned base64 plot from Railway backend
    // Now we'll return null and handle plotting in Flutter
    return null;
  }

  // Fetch all extra stats (simplified version)
  static Future<Map<String, dynamic>> getExtras(String district, String block) async {
    final response = await _get("$baseUrl/groundwater?select=*&district=ilike.$district&block=ilike.$block&order=datetime_ts.desc&limit=100");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) return {};
      
      // Calculate basic stats from raw data
      final latest = data.first;
      final waterLevels = data.map((e) => e['water_level'] as double? ?? 0.0).toList();
      final avgLevel = waterLevels.reduce((a, b) => a + b) / waterLevels.length;
      
      return {
        'last_date': latest['datetime_ts'],
        'latest_level': latest['water_level'],
        'avg_level': avgLevel,
        'rainfall': latest['rainfall_mm'] ?? 0,
        'aquifer_type': latest['aquifer_type'] ?? 'Unknown',
        'sustainability_score': _calculateScore(waterLevels),
      };
    }
    throw Exception("Failed to load extras");
  }

  static double _calculateScore(List<double> levels) {
    if (levels.isEmpty) return 0.0;
    final avg = levels.reduce((a, b) => a + b) / levels.length;
    return (avg / 10).clamp(0.0, 10.0); // Simple scoring
  }

  // Get daily fluctuation (simplified)
  static Future<Map<String, dynamic>?> getDailyFluctuation(String district, String block) async {
    final response = await _get("$baseUrl/groundwater?select=datetime_ts,water_level&district=ilike.$district&block=ilike.$block&order=datetime_ts.desc&limit=2");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.length >= 2) {
        final latest = data[0]['water_level'] as double? ?? 0.0;
        final previous = data[1]['water_level'] as double? ?? 0.0;
        final fluctuation = latest - previous;
        
        return {
          'fluctuation': fluctuation,
          'trend': fluctuation > 0 ? 'rising' : fluctuation < 0 ? 'falling' : 'stable',
          'latest_level': latest,
          'previous_level': previous,
        };
      }
    }
    return null;
  }
}
