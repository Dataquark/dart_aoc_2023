import 'dart:io';

void main() async {
  final inputFile = File('./lib/puzzle_01/input/01.txt');

  int theResult = await calibrationSum(inputFile);
  print(theResult);
}

Future<int> calibrationSum(File fileInput) async {
  /* The following approach is taken
    1. Read the txt input file as lines, which will return List<String>
    2. For each string in the list apply a regex rule (firstMatch) twice
        - one for the original string
        - one for reversed string
        - it will result in the first and the last digit in a string
        - if string has one digit, procedure duplicates it per example in the task.md
    3. Join the numbers to form a 2 digit number and cast it into Integer
    4. Add the resulting integer to the finalSum, which is initialized on 0
  */

  // ([0-9]) matches any numbers
  RegExp exp = RegExp(r"([0-9])");
  List<String> stringList = await fileInput.readAsLines();

  int finalSum = 0;

  for (var s in stringList) {
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
