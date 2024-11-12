class LottoNumberState {
  final Map<int, int>? frequencyNumberMap;
  final List<int>? sortedNumbers;
  final String? dialogTitle;
  final bool isLoading;
  final String? errorMessage;

  LottoNumberState({
    this.frequencyNumberMap,
    this.sortedNumbers,
    this.dialogTitle,
    this.isLoading = false,
    this.errorMessage,
  });

  LottoNumberState copyWith({
    Map<int, int>? frequencyNumberMap,
    List<int>? sortedNumbers,
    String? dialogTitle,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LottoNumberState(
      frequencyNumberMap: frequencyNumberMap ?? this.frequencyNumberMap,
      sortedNumbers: sortedNumbers ?? this.sortedNumbers,
      dialogTitle: dialogTitle ?? this.dialogTitle,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}