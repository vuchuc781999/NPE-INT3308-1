if [ $# -eq 1 ]; then
  grep "^s.*_$1_ AGT.*\[$1:.*" wireless1-out.tr | wc -l
fi
