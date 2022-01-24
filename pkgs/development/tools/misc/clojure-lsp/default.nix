{ lib, stdenv, buildGraalvmNativeImage, babashka, fetchurl, fetchFromGitHub, clojure, writeScript }:

buildGraalvmNativeImage rec {
  pname = "clojure-lsp";
  version = "2022.01.22-01.31.09";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-xQSOJRKKjX3AfQsYe4UNhFlLgWPkoY8NOPXCO1oc3BI=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp-standalone.jar";
    sha256 = "sha256-le0+ZmGyhM/UfGUV05FHyx5PlARxL/T2aC8UhiPYjxw";
  };

  # https://github.com/clojure-lsp/clojure-lsp/blob/2022.01.22-01.31.09/cli/graalvm/native-unix-compile.sh#L18-L27
  # Needs to be inject on `nativeImageBuildArgs` inside shell environment,
  # otherwise we can't expand to the value set in `mktemp -d` call
  preBuild = ''
    export DTLV_LIB_EXTRACT_DIR="$(mktemp -d)"
    nativeImageBuildArgs+=("-H:CLibraryPath=$DTLV_LIB_EXTRACT_DIR")
  '';

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

    old_jar_hash=$(nix-instantiate --eval --strict -A "clojure-lsp-standalone.jar.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')

    curl -o clojure-lsp.jar -sL https://github.com/clojure-lsp/clojure-lsp/releases/download/$latest_version/clojure-lsp-standalone.jar
    new_jar_hash=$(nix-hash --flat --type sha256 clojure-lsp-standalone.jar | sed -re 's|[+]|\\&|g')

    rm -f clojure-lsp-standalone.jar

    nixFile=$(nix-instantiate --eval --strict -A "clojure-lsp.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')

    sed -i "$nixFile" -re "s|\"$old_jar_hash\"|\"$new_jar_hash\"|"
    update-source-version clojure-lsp "$latest_version"
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo babariviere ];
    # Depends on datalevin that is x86_64 only
    # https://github.com/juji-io/datalevin/blob/bb7d9328f4739cddea5d272b5cd6d6dcb5345da6/native/src/java/datalevin/ni/Lib.java#L86-L102
    broken = !stdenv.isx86_64;
  };
}
