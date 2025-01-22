class StronzLoadingPhase {
    final double weight;
    final int allowedFails;

    const StronzLoadingPhase({
        required this.weight,
        this.allowedFails = 0
    });
}
