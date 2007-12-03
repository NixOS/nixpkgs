set -e

$cp $tar .tar.bz2
$bzip2 -d .tar.bz2

$bzip2 -d < $tarball | ./.tar xvf -

$cp -prd * $out
