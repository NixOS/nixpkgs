set -e
echo "downloading $out from $url"
$curl/bin/curl --fail --location --max-redirs 20 "$url" > "$out"
