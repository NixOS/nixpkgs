. $stdenv/setup

ensureDir $out

dot2pdf() {
    sourceFile=$1
    targetName=$out/$(basename $(stripHash $sourceFile; echo $strippedName) .dot).pdf
    echo "convering $sourceFile to $targetName..."
    dot -Tps $sourceFile > tmp.ps
    epstopdf --outfile $targetName tmp.ps
}

for i in $dotGraph; do
    if test -d $i; then
        for j in $i/*; do dot2pdf $j; done
    else
        dot2pdf $i
    fi
done

