source $stdenv/setup

mkdir $out
result="$(cygpath --mixed $path)"
echo "\"$result\"" > $out/default.nix
