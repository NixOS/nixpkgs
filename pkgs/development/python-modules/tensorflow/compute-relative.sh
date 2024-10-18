#!@bash@
base="$1/"
target="$2"
while true
    do echo "$base" | grep -q / || break
    base_component="`echo "$base" | sed s,/.*,,`"
    target_component="`echo "$target" | sed s,/.*,,`"
    test "X$base_component" != "X$target_component" && break
    base="`echo "$base" | sed "s<^$base_component/<<"`"
    target="`echo "$target" | sed "s<^$target_component/<<"`"
done
echo "$target"
