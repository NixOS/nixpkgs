source $stdenv/setup

mkdir -p $out/share/dictd/
cd $out/share/dictd

python -O "$convert" "$src"
dictzip wiktionary-en.dict
echo en_US.UTF-8 > locale
