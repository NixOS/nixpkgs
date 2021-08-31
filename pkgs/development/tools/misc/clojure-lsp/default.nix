{ lib, stdenv, graalvm11-ce, babashka, fetchurl, fetchFromGitHub, clojure }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.07.12-12.30.59";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0iky3yh548xn28285x8gnjzc00f3i2b415wb2dhd9p9y2bgzhkld";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "02k1k0slh1lm7k43d52jvgl0fdyp9gcr8csbr6yi71qbhy0axrmp";
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
    ${babashka}/bin/bb integration-test/run-all.clj ./clojure-lsp

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
