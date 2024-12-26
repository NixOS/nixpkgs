p=( $(fc-list : file | sed "s@/[^/]*: @@" | sort -u) )
IFS=:
export GDFONTPATH="${GDFONTPATH}${GDFONTPATH:+:}${p[*]}"
unset IFS p
