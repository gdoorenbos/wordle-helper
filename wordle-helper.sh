# options:
# -s, --solution        A string representing the currently known solution. Defaults to "....."
# -h, --hint "....."    A string of len 5. Corresponds to a yellow letter hint, where the letter is in the solution at a different posistion. Four characters must be ".", and the fifth character must be a letter at the position where the game gave us a yellow square.
# -e, --exclude         A list of letters that are known not to be in the solution. Default is empty.

declare SOLN="....."
declare EXCLUDES=""
declare -a HINTS=()

# Note that we use "$@" to let each command-line parameter expand to a
# separate word. The quotes around "$@" are essential!
# We need TEMP as the 'eval set --' would nuke the return value of getopt.
TEMP=$(getopt -o 's:h:e:' --long 'solution:,hint:,exclude:' -n "$0" -- "$@")

if [ $? -ne 0 ]; then
    echo 'Terminating...' >&2
    exit 1
fi

# Note the quotes around "$TEMP": they are essential!
eval set -- "$TEMP"
unset TEMP

while true; do
    case "$1" in
        '-s'|'--solution')
            SOLN="$2"
            shift 2
            continue
        ;;
        '-h'|'--hint')
            HINTS+=("$2")
            shift 2
            continue
        ;;
        '-e'|'--exclude')
            EXCLUDES+="$2"
            shift 2
            continue
        ;;
        '--')
            shift
            break
        ;;
        *)
            echo 'Internal error!' >&2
            exit 1
        ;;
    esac
done

#if arg; then
#    echo 'Remaining arguments:'
#    for arg; do
#        echo "--> '$arg'"
#    done
#fi

#echo "solution: $SOLN"
#echo "excludes: $EXCLUDES"
#echo "hints: ${#HINTS[@]} ${HINTS[@]}"

if [ ${#SOLN} -ne 5 ]; then
    echo "ERROR: Bad solution given - '$SOLN'" >&2
    exit 1
fi

for hint in ${HINTS[@]}; do
    if [ ${#hint} -ne 5 ]; then
        echo "ERROR: Bad hint given - '$hint'" >&2
        exit 1
    fi
done

CMD="grep $SOLN words.txt"

if [ -n "$EXCLUDES" ]; then
    CMD+=" | grep -v \"[$EXCLUDES]\""
fi

for hint in ${HINTS[@]}; do
    for i in $(seq 5); do
        letter=$(echo "$hint" | head -c $i | tail -c 1)
        if [[ "$letter" != "." ]]; then
            #echo "i: $i"
            #echo "letter: $letter"
            filter=""
            for j in $(seq 1 $((i-1))); do
                filter+="."
            done
            filter+="$letter"
            for j in $(seq $i 4); do
                filter+="."
            done
            #echo "filter: $filter"

            CMD+=" | grep -v $filter"
            CMD+=" | grep $letter"
        fi
    done
done

echo "$CMD"
eval "$CMD"
