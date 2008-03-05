source $stdenv/setup

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
    bzip2 $tmpFile
    exit 1
}

runLaTeX() {
    if ! $latex $latexFlags $rootName >$tmpFile 2>&1; then showError; fi
    runNeeded=
    if fgrep -q \
        -e "LaTeX Warning: Label(s) may have changed." \
        -e "Rerun to get citations correct." \
        "$tmpFile"; then
        runNeeded=1
    fi
}

echo


echo "PASS 1..."
runLaTeX
echo


if grep -q '\\citation' $rootNameBase.aux; then
    echo "RUNNING BIBTEX..."
    bibtex --terse $rootNameBase
    cp $rootNameBase.bbl $out
    runNeeded=1
    echo
fi


if test "$runNeeded"; then
    echo "PASS 2..."
    runLaTeX
    echo
fi


if test -f $rootNameBase.idx; then
    echo "MAKING INDEX..."
    if test -n "$compressBlanksInIndex"; then
        makeindexFlags="$makeindexFlags -c"
    fi
    makeindex $makeindexFlags $rootNameBase.idx
    runNeeded=1
    echo
fi    


if test "$runNeeded"; then
    echo "PASS 3..."
    runLaTeX
    echo
fi


if test "$runNeeded"; then
    echo "Hm, still not done :-("
    echo
fi


if test -n "$generatePDF"; then
    cp $rootNameBase.pdf $out
else
    cp $rootNameBase.dvi $out
    if test -n "$generatePS"; then
        echo "CONVERTING TO POSTSCRIPT..."
        dvips $rootNameBase.dvi -o $out/$rootNameBase.ps
        echo
    fi
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

bzip2 $tmpFile
