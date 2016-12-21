{ writeScript, coreutils, gnugrep, jq, curl
}:

writeScript "update-tp_smapi" ''
PATH=${coreutils}/bin:${gnugrep}/bin:${jq}/bin:${curl}/bin

pushd pkgs/os-specific/linux/tp_smapi

tmpfile=`mktemp`
tags=`curl -s https://api.github.com/repos/evgeni/tp_smapi/tags`
latest_tag=`echo $tags | jq -r '.[] | .name' | grep -oP "^tp-smapi/\K.*" | sort --version-sort | tail -1`
sha256=`curl -sL "https://github.com/evgeni/tp_smapi/archive/tp-smapi/$latest_tag.tar.gz" | sha256sum | cut -d" " -f1`

cat > update.json <<EOF
{
  "version": "$latest_tag",
  "url": "https://github.com/evgeni/tp_smapi/archive/tp-smapi/$latest_tag.tar.gz",
  "sha256": "$sha256"
}
EOF

popd
''
