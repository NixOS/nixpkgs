{ lib, writeScript, coreutils, curl, gnugrep, jq, common-updater-scripts }:

writeScript "update-tp_smapi" ''
PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep jq ]}

tags=`curl -s https://api.github.com/repos/evgeni/tp_smapi/tags`
latest_tag=`echo $tags | jq -r '.[] | .name' | grep -oP "^tp-smapi/\K.*" | sort --version-sort | tail -1`

update-source-version linuxPackages.tp_smapi "$latest_tag"
''
