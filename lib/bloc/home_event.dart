abstract class HomeEvent {}

class FetchLottoNumbers extends HomeEvent {
  final int startNo;
  final int endNo;

  FetchLottoNumbers(this.startNo, this.endNo);
}

class SaveLottoNumbers extends HomeEvent {
  final String title;
  final List<int> sortedNum;
  final Map<int, int> numMap;

  SaveLottoNumbers(this.title, this.sortedNum, this.numMap);
}
