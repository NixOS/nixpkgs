{ writeScript
, lib
, curl
, runtimeShell
, jq
, nix-update
}:

writeScript "update-overleaf" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ curl jq nix-update ]}

  set -euo pipefail

  tag=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags" | jq -r .results[2].name)
  rev=$(curl -s "https://hub.docker.com/v2/repositories/sharelatex/sharelatex/tags/$tag/images" | jq .[0].layers | grep -Po "MONOREPO_REVISION=\K[a-z0-9]*" -m 1)

  nix-update --version branch=$rev overleaf
''

