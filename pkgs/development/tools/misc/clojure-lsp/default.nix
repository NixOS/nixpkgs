{ lib, stdenv, callPackage, fetchFromGitHub, leiningen, openjdk11
, graalvm11-ce, babashka }:

let
  pname = "clojure-lsp";
  version = "2021.02.14-19.46.47";
  leiningen11 = leiningen.override ({ jdk = openjdk11; });

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Zj7/8RcuxCy2xdd+5jeOb1GTsQsX0EVW32k32fA6uf4=";
  };

  repository = callPackage ./repository.nix {
    inherit src pname version;
    leiningen = leiningen11;
  };
in stdenv.mkDerivation rec {
  inherit src pname version;

  postPatch = ''
    # Hack to set maven cache in another directory since MAVEN_OPTS doesn't work
    substituteInPlace project.clj \
      --replace ":main" ":local-repo \"${repository}\" :main"
  '';

  GRAALVM_HOME = graalvm11-ce;

  buildInputs = [ graalvm11-ce leiningen11 repository ];

  buildPhase = with lib; ''
    runHook preBuild

    export LEIN_HOME="$(mktemp -d)"
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

    ${babashka}/bin/bb ./integration-test/run-all.clj ./clojure-lsp

    runHook postCheck
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = graalvm11-ce.meta.platforms;
  };
}
