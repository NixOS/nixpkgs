set -x
set -e

PATH=$coreutils/bin

mkdir $out

cat > $out/setup <<EOF
PATH=$coreutils/bin:$gnused/bin
EOF