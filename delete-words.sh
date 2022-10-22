set -e

WORDS_FILE="words.txt"

for i do
    sed -i "/$i/d" $WORDS_FILE
done
