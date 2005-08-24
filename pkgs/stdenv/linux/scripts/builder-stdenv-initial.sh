set -e

PATH=$staticTools/bin

mkdir $out

cat > $out/setup <<EOF
PATH=$staticTools/bin
EOF
