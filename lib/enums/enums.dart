enum CartStatus {
  pending,
  checkedOut,
  canceled,
}

// Extension to convert between enum and database string representation
extension CartStatusExtension on CartStatus {
  String toDatabaseValue() {
    switch (this) {
      case CartStatus.pending:
        return 'PENDING';
      case CartStatus.checkedOut:
        return 'CHECK_OUT';
      case CartStatus.canceled:
        return 'CANCEL';
    }
  }

  static CartStatus fromDatabaseValue(String value) {
    switch (value) {
      case 'PENDING':
        return CartStatus.pending;
      case 'CHECK_OUT':
        return CartStatus.checkedOut;
      case 'CANCEL':
        return CartStatus.canceled;
      default:
        throw ArgumentError('Invalid CartStatus value: $value');
    }
  }
}
