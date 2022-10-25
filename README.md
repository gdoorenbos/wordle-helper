# wordle-helper
Helps solve Wordle puzzles

# Usage
```
-s|--solution    solution    A string of 5 letters representing the current known solution (green letters).
                             Represent Unknown letters with a literal '.'
                             example: -s ".o.g."
-h|--hint        hint        A string of 5 letters including 4 literal '.' characters and one alphabet character.
                             This hint represents a yellow letter in-game. The given letter is present in the answer,
                             but is in the wrong location. This option may be given multiple times for multiple yellow
                             letters.
                             example: -h "..f.."
-e|--exclude     letters     A string of letters that are known not to exist in the answer. These are darkened letters in-game.
                             example: -e "abcdefg"
```

# Output
A list of words that match the given criteria.

# Example
```
$ ./wordle-helper.sh --solution ".o.g." --hint "..f.." --exclude "rse"
foggy
```
