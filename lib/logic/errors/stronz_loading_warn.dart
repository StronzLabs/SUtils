abstract class StronzLoadingWarn implements Exception {
    final String message;
    StronzLoadingWarn(this.message);

    @override
    String toString() => this.message;
}
