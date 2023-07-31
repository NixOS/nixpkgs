{ lib
, writeScript
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
, protobuf
, pycryptodome
, zstandard
, json5
, platformdirs
, cacert
}:

buildPythonApplication rec {
  pname = "nile";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "f5f3b96f6483c59cfc646afbda6e97cb0bd94778";
    hash = "sha256-HibY3U9/MibEDwHY+YiErW/pz6qwtps8wwjhznTISgA=";
  };

  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    setuptools
    requests
    protobuf
    pycryptodome
    zstandard
    json5
    platformdirs
  ];

  pyprojectAppendix = ''
    [tool.setuptools.packages.find]
    include = ["nile*"]
  '';

  postPatch = ''
    echo "$pyprojectAppendix" >> pyproject.toml
  '';

  pythonImportsCheck = [ "nile" ];

  meta = with lib; {
    description = "Unofficial Amazon Games client";
    homepage = "https://github.com/imLinguin/nile";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ aidalgol ];
  };

  # Upstream does not create git tags when bumping the version, so we have to
  # extract it from the source code on the main branch.
  passthru.updateScript = writeScript "gogdl-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnused jq common-updater-scripts
    set -eou pipefail;

    owner=imLinguin
    repo=nile
    path='nile/__init__.py'

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
      --file=./pkgs/games/nile/default.nix \
      --rev=$commit
  '';
}
