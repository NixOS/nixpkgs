mkdir -p $out

for ((i = 1; i <= $nrFrames; i++)); do
    echo "producing frame $i...";
    targetName=$out/$(basename $(stripHash $dotGraph) .dot)-f-$i.dot
    cpp -DFRAME=$i < $dotGraph > $targetName
done
