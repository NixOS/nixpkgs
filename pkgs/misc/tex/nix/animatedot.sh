. $stdenv/setup

ensureDir $out

for i in $(seq 1 $nrFrames); do
    echo "producing frame $i...";
    targetName=$out/$(basename $(stripHash $dotGraph; echo $strippedName) .dot)-f-$i.dot
    cpp -DFRAME=$i < $dotGraph > $targetName
done
