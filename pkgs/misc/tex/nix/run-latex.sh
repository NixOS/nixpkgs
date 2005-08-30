. $stdenv/setup

ensureDir $out

startDir=$(perl $copyIncludes $includes)
cd $startDir

for i in $extraFiles; do
    if test -d $i; then
        ln -s $i/* .
    else
        ln -s $i $(stripHash $i; echo $strippedName)
    fi
done

rootName=$(basename $(stripHash "$rootFile"; echo $strippedName))

rootNameBase=$(echo "$rootName" | sed 's/\..*//')

if test -n "$generatePDF"; then
    latex=pdflatex
else
    latex=latex
fi

latexFlags="-file-line-error"
tmpFile=$out/log

showError() {
    echo
    echo "LATEX ERROR (LAST LOG LINES SHOWN):"
    tail -n 20 $tmpFile
    exit 1
}

runLaTeX() {
if ! $latex $latexFlags $rootName >$tmpFile 2>&1; then showError; fi
}

echo

echo "PASS 1..."
runLaTeX
echo

if grep -q '\\citation' $rootNameBase.aux; then
    echo "RUNNING BIBTEX..."
    bibtex --terse $rootNameBase
    echo
fi

echo "PASS 2..."
runLaTeX
echo

if test -f $rootNameBase.idx; then
    echo "MAKING INDEX..."
    makeindex $rootNameBase.idx
    echo
fi    

echo "PASS 3..."
runLaTeX
echo
if test -n "$generatePDF"; then
    cp $rootNameBase.pdf $out
else
    cp $rootNameBase.dvi $out
fi

echo "OVERFULL/UNDERFULL:"
cat $tmpFile | egrep "Overfull|Underfull" || true

echo
echo "UNDEFINED REFERENCES:"
cat $tmpFile | grep "Reference.*undefined" || true

echo
echo "UNDEFINED CITATIONS:"
cat $tmpFile | grep "Citation.*undefined" || true

echo
echo "STATS:"
printf "%5d overfull/underfull h/vboxes\n" $(cat $tmpFile | egrep -c "Overfull|Underfull" || true)
printf "%5d undefined references\n" $(cat $tmpFile | grep -c "Reference.*undefined" || true)
printf "%5d undefined citations\n" $(cat $tmpFile | grep -c "Citation.*undefined" || true)
printf "%5d pages\n" \
    $(cat $tmpFile | grep "Output written.*(.*pages" | sed "s/.*(\([0-9]*\) pages.*/\1/" || true)
echo
