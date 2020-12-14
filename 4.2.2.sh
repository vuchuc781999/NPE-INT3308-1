if [ $# -eq 1 ]; then
  grep "^r.*_$1_ MAC.* $1:.*" wireless1-out.tr | wc -l
fi
