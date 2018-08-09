version=1.9.0
hashfile=tf${version}-hashes.nix
rm -f $hashfile
echo "{" >> $hashfile
for sys in "linux" "mac"; do
    for tfpref in "cpu/tensorflow" "gpu/tensorflow_gpu"; do
        for pykind in "py2-none-any" "py3-none-any" "cp27-none-linux_x86_64" "cp35-cp35m-linux_x86_64" "cp36-cp36m-linux_x86_64"; do
            if [ $sys == "mac" ]; then
               [[ $pykind =~ py.* ]] && [[ $tfpref =~ cpu.* ]]
               result=$?
               pyver=${pykind:2:1}
               flavour=cpu
            else
               [[ $pykind =~ .*linux.* ]]
               result=$?
               pyver=${pykind:2:2}
               flavour=${tfpref:0:3}
            fi
            if [ $result == 0 ]; then
                url=https://storage.googleapis.com/tensorflow/$sys/$tfpref-$version-$pykind.whl
                hash=$(nix-prefetch-url $url)
                echo "${sys}_py_${pyver}_${flavour} = {" >> $hashfile
                echo "  url = \"$url\";" >> $hashfile
                echo "  sha256 = \"$hash\";" >> $hashfile
                echo "};" >> $hashfile
            fi
        done
    done
done
echo "}" >> $hashfile
