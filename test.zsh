# Test of Select and Case statement for easy
# UI selection.
# 
SWARM_NODES=("ws01" "ws02" "ws03" "Quit")
PS3='Choose your favorite food: '
select fav in "${SWARM_NODES[@]}"; do
    case $fav in
    "${SWARM_NODES[0]}")
        echo "Americans eat roughly 100 acres of $fav each day!"
        # optionally call a function or run some code here
        ;;
    "${SWARM_NODES[1]}")
        echo "$fav is a Vietnamese soup that is commonly mispronounced like go, instead of duh."
        # optionally call a function or run some code here
        ;;
    "${SWARM_NODES[2]}")
        echo "According to NationalTacoDay.com, Americans are eating 4.5 billion $fav each year."
        # optionally call a function or run some code here
        break
        ;;
    "${SWARM_NODES[3]}")
        echo "User requested exit"
        exit
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
done
