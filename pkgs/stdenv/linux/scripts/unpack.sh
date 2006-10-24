set -e

$cp $tar .tar.bz2
$bunzip2 .tar.bz2

$bunzip2 -d < $tarball | ./.tar xvf -

$cp -prd * $out
