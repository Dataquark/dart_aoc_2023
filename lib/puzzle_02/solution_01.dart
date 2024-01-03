import 'dart:convert';
import 'dart:io';

void main() async {
  final inputFile = File('./lib/puzzle_02/input/input.txt');

  final Map<String, List> mappedGame = await gameMapper(inputFile);

  int theResult = sumPossibleGames(mappedGame);

  print(theResult);
}

Future gameMapper(File file) async {
  /*
    ACCEPTS: input file

    RETURNS: Map<KEY, VALUE>
      KEY<String>:   Game 1, Game 2, etc
      VALUE<List>:   List of drawn cubes for each game in a separate Map<color, number>

      EXAMPLE: {
        "Game 1": [
          {"green": 6, "blue": 3},
          {"red": 3, "green": 1},
          {"green": 4, "red": 3, "blue": 5},
        ],
        "Game 2": ...
      }

    DETAILS:
      - we read the file as a transformed Stream<String>
      - we create an emptly listOfDraws to be populated
      - each line is split on ":", which results in a list,
        the first item of this list is the game number
      - the second item is also then split on ";"
        which gives a list of subset of cube draws
      - for each subset, we create an innerMap, which will have the
        individual cube draws (color:number)
      - each subset of draws is further split on "," within a for loop
        - each individual draw is trimmed and split on " " (space)
        - finally, second item of this individual draw is the key of innerMap
          while the first item is the value
      - innerMap is added to the listOfDraws, which is itself added to the RETURN map    
  */
  Map<String, List<Map<String, int>>> allGames = {};

  Stream<String> lines =
      file.openRead().transform(utf8.decoder).transform(LineSplitter());

  try {
    await for (var line in lines) {
      List<Map<String, int>> listOfDraws = [];

      // return a list of ["Game 1", "...."]
      // games[0] will be the number of the game
      List<String> games = line.split(':');

      // return a list of subset of cube draws
      // first iteration: ["6 green, 3 blue", "3 red, 1 green", "4 green, 3 red, 5 blue"]
      List<String> gameData = games[1].split(';');

      for (String subset in gameData) {
        // inner map that will go into the listOfDraws
        Map<String, int> innerMap = {};

        // first iteration: ["6 green", "3 blue"]
        List<String> cubeDraws = subset.split(',');

        for (var draw in cubeDraws) {
          // first iteration: ["6", "green"]
          var i = draw.trim().split(' ');
          innerMap[i[1]] = int.parse(i[0]);
        }
        listOfDraws.add(innerMap);
      }
      allGames[games[0]] = listOfDraws;
    }

    // processed Map of games
    return allGames;
  } catch (e) {
    return e;
  }
}

int sumPossibleGames(Map<String, List> gameMap) {
  // might be a good case for pattern matching with switch -> case

  // pmaximum possible configuration of cube draws
  const int red = 12;
  const int green = 13;
  const int blue = 14;

  // sum of the possible games
  int gameSum = 0;
  gameMap.forEach((key, value) {
    // as soon as a cube drawn that is bigger than the configuration
    // this variable is changed to false
    bool gamePossible = true;

    for (Map<String, int> game in value) {
      game.forEach((k, v) {
        if (k == 'red' && v > red) {
          gamePossible = false;
        } else if (k == 'green' && v > green) {
          gamePossible = false;
        } else if (k == 'blue' && v > blue) {
          gamePossible = false;
        }
      });
    }

    // if game passes the if checks then the sum of game number is returned
    if (gamePossible) {
      gameSum += int.parse(key.split(' ')[1]);
      print('$key is possible: $gamePossible = $gameSum');
    }
  });

  return gameSum;
}
