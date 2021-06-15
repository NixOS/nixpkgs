{ lib, stdenv, graalvm11-ce, babashka, fetchurl, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.06.01-16.19.44";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-dACvjm+uEVWotoeYhA4gCenKeprpF2dI0PGNRAVALao=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp.jar";
    sha256 = "sha256-V12rSYv/Yu12ZpLSROd+4pyGiEGRfJ7lmRqCeikcQ5Q=";
  };

  GRAALVM_HOME = graalvm11-ce;
  CLOJURE_LSP_JAR = jar;

  buildInputs = [ graalvm11-ce ];

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
    maintainers = [ maintainers.ericdallo ];
    platforms = graalvm11-ce.meta.platforms;
  };
}
