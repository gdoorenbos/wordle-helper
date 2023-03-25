> char_counts.txt
for i in `seq 97 122`; do
    char=$(printf "\x$(printf "%x" $i)\n")
    count=$(grep -c $char words.txt)
    echo "$char $count" | tee -a char_counts.txt
done
