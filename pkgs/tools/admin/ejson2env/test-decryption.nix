{ ejson2env, runCommand }:
runCommand "check-ejson2env.sh" {
  nativeBuildInputs = [ ejson2env ];
} ''
  cat > $TMP/abc.ejson <<EOF
    {
      "_public_key": "349a0e027725db0693cf0505344c5104807d38fb398cd4597029dccc8d0d8711",
      "environment": {
        "foo": "EJ[1:7oqIDkyXLro12rcrg7/psjK5Qcfuw5FRquvfBaRUBic=:OTtncVl0wT4U6UWdxoaCGBRnM2WzGnV3:1FiIgHYT5U6MjFN8IUU83T1fzQ==]"
      }
    }
EOF
  response="$(echo "ff34961809e9d7a0ae20b9d09e5d8630c8d4924cef19cdb5385916b9be019954" | ejson2env --key-from-stdin $TMP/abc.ejson)"
  if [[ "$response" != "export foo=bar" ]]; then
    echo "test file not decrypted correctly"
    exit 1
  fi
  touch $out
''
