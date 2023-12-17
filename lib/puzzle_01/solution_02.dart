import "dart:io";

void main(List<String> args) async {
  final inputFile = File("./lib/puzzle_01/input/01.txt");
  int theResult = await realCalibrationSum(inputFile);
  print(theResult);
}

Future<int> realCalibrationSum(File inputFile) async {
  List<String> stringList = await inputFile.readAsLines();
  int finalSum = 0;

  for (var s in stringList) {
    print("$s is in progress");
  }

  return finalSum;
}
