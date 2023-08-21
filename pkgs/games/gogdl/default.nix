{ lib
, fetchpatch
, writeScript
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
, cacert
}:

buildPythonApplication rec {
  pname = "gogdl";
  version = "0.7.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    rev = "d2fa34bfba7beb2ecc0e3fc70a657f2c612c8a10";
    hash = "sha256-YCqtfY49lDg6sLrF/INOZVD9cMCwvejhySzUWrxHKAw=";
  };

  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    setuptools
    requests
  ];

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/Heroic-Games-Launcher/heroic-gogdl/pull/37.patch";
      hash = "sha256-oZLetPoWzsEDrL0Bh89HB4hTn70FTh8aXj9mKGr4Dqw=";
    })
  ];

  pythonImportsCheck = [ "gogdl" ];

  meta = with lib; {
    description = "GOG Downloading module for Heroic Games Launcher";
    homepage = "https://github.com/Heroic-Games-Launcher/heroic-gogdl";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ aidalgol ];
  };

  # Upstream no longer create git tags when bumping the version, so we have to
  # extract it from the source code on the main branch.
  passthru.updateScript = writeScript "gogdl-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnused jq common-updater-scripts
    set -eou pipefail;

    owner=Heroic-Games-Launcher
    repo=heroic-gogdl
    path='gogdl/__init__.py'

    version=$(
      curl --cacert "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      https://raw.githubusercontent.com/$owner/$repo/main/$path |
      sed -n 's/^\s*version\s*=\s*"\([0-9]\.[0-9]\.[0-9]\)"\s*$/\1/p')

    commit=$(curl --cacert "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      https://api.github.com/repos/$owner/$repo/commits?path=$path |
      jq -r '.[0].sha')

    update-source-version \
      ${pname} \
      "$version" \
      --file=./pkgs/games/gogdl/default.nix \
      --rev=$commit
  '';
}
