if test -z "$out"; then
  stdenv="$STDENV"
  url="$URL"
  id="$ID"
  outputHashAlgo="$OUTPUTHASHALGO"
  outputHash="$OUTPUTHASH"
  chmod=$CHMOD
  curl=$CURL
fi

source $stdenv/setup

if test -z "$out"; then
  out="$OUT"
fi

header "downloading $out from $url"
echo "curl is $curl"
$curl --fail --location --max-redirs 20 "$url" > "$out"

if test "$NIX_OUTPUT_CHECKED" != "1"; then
    if test "$outputHashAlgo" != "md5"; then
        echo "hashes other than md5 are unsupported in Nix <= 0.7, upgrade to Nix 0.8"
        exit 1
    fi
    actual=$(md5sum -b "$out" | cut -c1-32)
    if test "$actual" != "$id"; then
        echo "hash is $actual, expected $id"
        exit 1
    fi
fi

echo "chmod is $chmod"
$chmod a-x $out

stopNest
