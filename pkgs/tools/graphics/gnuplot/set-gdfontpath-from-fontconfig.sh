p=( $(for n in $(fc-list | sed -r -e 's|^([^:]+):.*$|\1|'); do echo $(dirname "$n"); done | sort | uniq) )
IFS=:
export GDFONTPATH="${GDFONTPATH}${GDFONTPATH:+:}${p[*]}"
unset IFS p
