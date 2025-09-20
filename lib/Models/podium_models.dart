class PodiumData {
  PodiumData({required this.seriesTitle, required this.raceTitle, required this.dateText, required this.trackName, required this.standings});

  final String seriesTitle; // e.g., Formula 1
  final String raceTitle; // e.g., Azerbaijan GP
  final String dateText; // e.g., tomorrow, 7:00 AM
  final String trackName; // e.g., Baku City Circuit
  final List<PodiumEntry> standings;
}

class PodiumEntry {
  PodiumEntry({required this.position, required this.driverName, required this.teamName, required this.vehicleNumber, required this.grid, required this.qualTime});

  final int position; // 1-based
  final String driverName; // e.g., M. Verstappen
  final String teamName; // e.g., Red Bull
  final String vehicleNumber; // e.g., #1
  final String grid; // e.g., 1
  final String qualTime; // e.g., 1:41.117 or DNF
}


