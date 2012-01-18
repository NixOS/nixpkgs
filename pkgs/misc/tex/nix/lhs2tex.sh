source $stdenv/setup

mkdir -p $out

mkdir root
cd root

startDir=$(perl $copyIncludes $includes)
cd $startDir

lhstex() {
    sourceFile=$1
    targetName=$out/$(basename $(stripHash $sourceFile; echo $strippedName) .lhs).tex
    echo "converting $sourceFile to $targetName..."
    lhs2TeX -o "$targetName" $flags "$sourceFile"
}

lhstex $source

