{ lib, stdenv, graalvm11-ce, babashka, fetchurl, fetchFromGitHub, clojure, writeScript }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.09.30-15.28.01";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "i7HCVcQa35pRnk7uXf+8PQ4IMpdSVrT7FKvguvzOvj4=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "27a1ca0ca96cf0b5177a76679c6b7d09e6e02dca4c85fd252f7b2c43ef39b89a";
  };

  GRAALVM_HOME = graalvm11-ce;
  CLOJURE_LSP_JAR = jar;
  CLOJURE_LSP_XMX = "-J-Xmx4g";

  buildInputs = [ graalvm11-ce clojure ];

  buildPhase = with lib; ''
    runHook preBuild

    # https://github.com/clojure-lsp/clojure-lsp/blob/2021.09.30-15.28.01/graalvm/native-unix-compile.sh#L19-L24
    args=("-jar" "$CLOJURE_LSP_JAR"
          "-H:CLibraryPath=${graalvm11-ce.lib}/lib"
          "-H:+ReportExceptionStackTraces"
          "--verbose"
          "--no-fallback"
          "--native-image-info"
          "$CLOJURE_LSP_XMX")

    native-image ''${args[@]}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./clojure-lsp $out/bin/clojure-lsp

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export HOME="$(mktemp -d)"
    ./clojure-lsp --version | fgrep -q '${version}'
    ${babashka}/bin/bb integration-test ./clojure-lsp

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
    platforms = graalvm11-ce.meta.platforms;
  };
}
