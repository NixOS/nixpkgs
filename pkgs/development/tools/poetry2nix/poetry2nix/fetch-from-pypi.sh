source $stdenv/setup
set -euo pipefail

curl="curl            \
 --location           \
 --max-redirs 20      \
 --retry 2            \
 --disable-epsv       \
 --cookie-jar cookies \
 --insecure           \
 --speed-time 5       \
 --progress-bar       \
 --fail               \
 $curlOpts            \
 $NIX_CURL_FLAGS"

echo "Trying to fetch with predicted URL: $predictedURL"

$curl $predictedURL --output $out && exit 0

echo "Predicted URL '$predictedURL' failed, querying pypi.org"
$curl "https://pypi.org/pypi/$pname/json" | jq -r ".releases.\"$version\"[] | select(.filename == \"$file\") | .url" > url
url=$(cat url)
$curl -k $url --output $out
