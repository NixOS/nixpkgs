set -e

PATH=$coreutils/bin

mkdir $out

cat > $out/setup <<EOF
PATH=$staticTools/bin
EOF
