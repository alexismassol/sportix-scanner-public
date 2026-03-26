class ScanResult {
  final String status;
  final String message;
  final String? ticketId;
  final String? holderName;
  final String? seatInfo;
  final String? scannedAt;
  final double? previousBalance;
  final double? newBalance;
  final double? amount;
  final double? currentBalance;
  final double? requiredAmount;
  final DateTime timestamp;

  ScanResult({
    required this.status,
    required this.message,
    this.ticketId,
    this.holderName,
    this.seatInfo,
    this.scannedAt,
    this.previousBalance,
    this.newBalance,
    this.amount,
    this.currentBalance,
    this.requiredAmount,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      status: json['status'] as String,
      message: json['message'] as String,
      ticketId: json['ticketId'] as String?,
      holderName: json['holderName'] as String?,
      seatInfo: json['seatInfo'] as String?,
      scannedAt: json['scannedAt'] as String?,
      previousBalance: (json['previousBalance'] as num?)?.toDouble(),
      newBalance: (json['newBalance'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      currentBalance: (json['currentBalance'] as num?)?.toDouble(),
      requiredAmount: (json['requiredAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'ticketId': ticketId,
      'holderName': holderName,
      'seatInfo': seatInfo,
      'scannedAt': scannedAt,
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'amount': amount,
      'currentBalance': currentBalance,
      'requiredAmount': requiredAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get isValid => status == 'valid';
  bool get isAlreadyScanned => status == 'already_scanned';
  bool get isRefunded => status == 'refunded';
  bool get isInvalid => status == 'invalid';
  bool get isInsufficient => status == 'insufficient';
}
