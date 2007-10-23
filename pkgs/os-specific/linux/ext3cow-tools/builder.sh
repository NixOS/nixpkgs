source $stdenv/setup

tar -zxvf $src
cd ext3cow-tools/

echo "Using: $kernel"

kernelslashed=$(echo $kernel | sed 's/\//\\\//g')
sed -i "s/linux\/ext3cow_fs.h/$kernelslashed\/lib\/modules\/2.6.21.5-default\/build\/include\/linux\/ext3cow_fs.h/" ext3cow_tools.h		#ugh dirty header rewrite....

make

ensureDir $out/bin/
cp ss $out/bin/snapshot
cp tt $out/bin/
cp e2d $out/bin/
