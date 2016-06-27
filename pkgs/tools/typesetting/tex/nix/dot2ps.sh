source $stdenv/setup

mkdir -p $out

dot2ps() {
    sourceFile=$1
    targetName=$out/$(baseHash $sourceFile .dot).ps
    echo "converting $sourceFile to $targetName..."
    dot -Tps $sourceFile > $targetName
}

for i in $dotGraph; do
    if test -d $i; then
        for j in $i/*; do dot2ps $j; done
    else
        dot2ps $i
    fi
done

