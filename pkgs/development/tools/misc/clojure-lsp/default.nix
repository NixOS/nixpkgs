{ lib, stdenv, buildGraalvmNativeImage, babashka, fetchurl, fetchFromGitHub, clojure, writeScript }:

buildGraalvmNativeImage rec {
  pname = "clojure-lsp";
  version = "2021.11.02-15.24.47";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-PBbo8yx4g4SsViUA1jnwqF8q9Dfn3lrgK2CP026Bm4Q=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "sha256-k0mzibcLAspklCPE6f2qsUm9bwSvcJRgWecMBq7mpF0=";
  };

  # https://github.com/clojure-lsp/clojure-lsp/blob/2021.11.02-15.24.47/graalvm/native-unix-compile.sh#L18-L27
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
    ${babashka}/bin/bb integration-test ./${pname}

    runHook postCheck
  '';

  passthru.updateScript = writeScript "update-clojure-lsp" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts gnused jq nix

    set -eu -o pipefail

    latest_version=$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest | jq --raw-output .tag_name)

    old_jar_hash=$(nix-instantiate --eval --strict -A "clojure-lsp.jar.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')

    curl -o clojure-lsp.jar -sL https://github.com/clojure-lsp/clojure-lsp/releases/download/$latest_version/clojure-lsp.jar
    new_jar_hash=$(nix-hash --flat --type sha256 clojure-lsp.jar | sed -re 's|[+]|\\&|g')

    rm -f clojure-lsp.jar

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
