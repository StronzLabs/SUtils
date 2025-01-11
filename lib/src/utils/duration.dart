extension DurationExtension on Duration {
    String format() {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitHours = twoDigits(this.inHours.remainder(60));
        String twoDigitMinutes = twoDigits(this.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(this.inSeconds.remainder(60));
        return "${this.inHours.remainder(60) > 0 ? "${twoDigitHours}:" : ""}${twoDigitMinutes}:${twoDigitSeconds}";
    }
}
