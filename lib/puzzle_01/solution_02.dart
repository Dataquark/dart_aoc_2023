import "dart:io";

void main() async {
  final inputFile = File("./lib/puzzle_01/input/01.txt");

  // each key in a string will be replaced with value
  Map<String, String> digitMap = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9'
  };

  int theResult = await realCalibrationSum(inputFile, digitMap);
  print(theResult);
}

Future<int> realCalibrationSum(File inputFile, Map digitMap) async {
  RegExp exp = RegExp(r"([0-9])");
  List<String> stringList = await inputFile.readAsLines();

  int finalSum = 0;

  for (String s in stringList) {
    digitMap.forEach((key, value) {
      // we do this `$key$value$key` replacement to avoid overlapping numbers
      // example `twone` will become two2twoone in the first iteration
      // then two2twoone1one in the last iteration
      s = s.replaceAll(key, '$key$value$key');
    });

    // once we replace all the words with appropriate digits
    // we use the same method (forward, reverse regex) from the first solution
    // TODO: extract the solution to a separate method to DRY code
    final String rStr = s.split("").reversed.join();

    // null assertion as a string can't not contain digits per the task rules
    var a = exp.firstMatch(s)!;
    var b = exp.firstMatch(rStr)!;

    // write the two numbers as joined string and cast them into int
    // TODO: very ugly join, we should come up with better option
    final int intResult = int.parse("${a[0]}${b[0]}");

    finalSum = finalSum + intResult;
  }

  return finalSum;
}
