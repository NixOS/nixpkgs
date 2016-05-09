source "$stdenv"/setup

cp --recursive "$src" ./

chmod --recursive u=rwx ./"$(basename "$src")"

cd ./"$(basename "$src")"

cmake ./ 

make

mkdir --parents "$out"/bin
cp ./TraceFileGen "$out"/bin

mkdir --parents "$out"/share/doc/"$name"/html
cp --recursive ./Documentation/html/* "$out/share/doc/$name/html/"
