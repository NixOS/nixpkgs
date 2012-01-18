source $stdenv/setup

tail -n +165 $demo | tar xvfz -
chmod -R +w .
tail -n +175 $update | tar xvfz -
chmod -R +w .

mkdir -p $out/baseq3
cp demoq3/*.pk3 baseq3/*.pk3 $out/baseq3
