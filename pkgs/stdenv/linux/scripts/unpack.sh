set -e

$bunzip2 -d < $tarball | $tar xvf -

$cp -prd * $out

if test -n "$postProcess"; then
    for i in $addToPath; do
        export PATH=$PATH:$i/bin
    done
    for i in $postProcess; do
        source $i
    done
fi
