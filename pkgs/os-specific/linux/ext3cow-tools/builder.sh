source $stdenv/setup

tar -zxvf $src
cd ext3cow-tools/

echo "Using: $kernel"

kernerlext3cowheader=$(ls $kernel/lib/modules/*/build/include/linux/ext3cow_fs.h)

kernerlext3cowheader_slashed=$(echo $kernerlext3cowheader | sed 's/\//\\\//g')

sed -i "s/linux\/ext3cow_fs.h/$kernerlext3cowheader_slashed/" ext3cow_tools.h		#ugh dirty header rewrite....

make

ensureDir $out/bin/
cp ss $out/bin/snapshot
cp tt $out/bin/
cp e2d $out/bin/
