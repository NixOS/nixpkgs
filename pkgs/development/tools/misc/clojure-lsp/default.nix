{ lib, stdenv, buildGraalvmNativeImage, babashka, fetchurl, fetchFromGitHub, clojure, writeScript }:

buildGraalvmNativeImage rec {
  pname = "clojure-lsp";
  version = "2023.07.01-22.35.41";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-/gpynrmu9O6nRH5TzfXwxbPbpk7c6ZzwR6cp8F2puUM=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp-standalone.jar";
    sha256 = "90457834b079eea57d07b62a1281ebe91b7449d61da0f6e20d5b9f8f8163e525";
  };

  extraNativeImageBuildArgs = [
    "--no-fallback"
    "--native-image-info"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export HOME="$(mktemp -d)"
    ./${pname} --version | fgrep -q '${version}'
  ''
    # TODO: fix classpath issue per https://github.com/NixOS/nixpkgs/pull/153770
    #${babashka}/bin/bb integration-test ./${pname}
  + ''
    runHook postCheck
  '';

  passthru.updateScript = writeScript "update-clojure-lsp" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts gnused jq nix

    set -eu -o pipefail

    latest_version=$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest | jq --raw-output .tag_name)

    old_jar_hash=$(nix-instantiate --eval --strict -A "clojure-lsp.jar.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')

    curl -o clojure-lsp-standalone.jar -sL https://github.com/clojure-lsp/clojure-lsp/releases/download/$latest_version/clojure-lsp-standalone.jar
    new_jar_hash=$(nix-hash --flat --type sha256 clojure-lsp-standalone.jar | sed -re 's|[+]|\\&|g')

    rm -f clojure-lsp-standalone.jar

    nixFile=$(nix-instantiate --eval --strict -A "clojure-lsp.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')

    sed -i "$nixFile" -re "s|\"$old_jar_hash\"|\"$new_jar_hash\"|"
    update-source-version clojure-lsp "$latest_version"
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo babariviere ];
  };
}
