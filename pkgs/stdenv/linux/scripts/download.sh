set -e

$ln -s $curl curl.bz2
$bzip2 -d -f curl.bz2
./curl --version

echo "downloading $out from $url"
./curl --fail --location --max-redirs 20 "$url" > "$out"
