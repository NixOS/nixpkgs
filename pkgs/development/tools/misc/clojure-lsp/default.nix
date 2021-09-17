{ lib, stdenv, graalvm11-ce, babashka, fetchurl, fetchFromGitHub, clojure }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.09.04-17.11.44";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1i12vxg3yb1051q7j6yqlsdy4lc4xl7n4lqssp8w634fpx1p0rgv";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "0ahrlqzyz3mgfx8w9w49172pb3dipq0hwwzk2yasqzcp1fi6jm80";
  };

  GRAALVM_HOME = graalvm11-ce;
  CLOJURE_LSP_JAR = jar;
  CLOJURE_LSP_XMX = "-J-Xmx4g";

  buildInputs = [ graalvm11-ce clojure ];

  buildPhase = with lib; ''
    runHook preBuild

    bash ./graalvm/native-unix-compile.sh

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

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo babariviere ];
    platforms = graalvm11-ce.meta.platforms;
  };
}
