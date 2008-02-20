set -x
set -e

# Tricky: need to make $out/bin without mkdir ;-).  So use cp to copy
# the current (empty) directory.
$cp -prvd . $out
$cp -prvd . $out/bin

$cp $curl curl.bz2
$bzip2 -d curl.bz2
$cp curl $out/bin
