set -x
set -e

echo $curl

$bunzip2 -d < $curl | $tar xvf -

$cp -prvd * $out
