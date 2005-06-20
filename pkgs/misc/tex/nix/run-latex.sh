. $stdenv/setup

ensureDir $out

perl $copyIncludes $includes

#for i in $includes; do
#    if test -d $i; then
#        cp $i/* .
#    else
#        cp $i $(stripHash $i; echo $strippedName)
#    fi
#done

rootName=$(basename $(stripHash "$rootFile"; echo $strippedName))
echo "root name is $rootName"

rootNameBase=$(echo "$rootName" | sed 's/\..*//')

if test -n "$generatePDF"; then
    latex=pdflatex
else
    latex=latex
fi    

$latex $rootName

if grep -q '\\citation' $rootNameBase.aux; then
    bibtex $rootNameBase
fi

$latex $rootName

makeindex $rootNameBase.idx

$latex $rootName

if test -n "$generatePDF"; then
    cp $rootNameBase.pdf $out
else
    cp $rootNameBase.dvi $out
fi
