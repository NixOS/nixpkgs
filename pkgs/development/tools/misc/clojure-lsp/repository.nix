{ lib, stdenv, src, pname, version, leiningen }:

stdenv.mkDerivation {
  inherit src;

  name = "${pname}-${version}-repository";
  buildInputs = [ leiningen ];

  postPatch = ''
    # Hack to set maven cache in another directory since MAVEN_OPTS doesn't work
    substituteInPlace project.clj \
      --replace ":main" ":local-repo \"$out\" :main"
  '';

  buildPhase = ''
    runHook preBuild

    export LEIN_HOME="$(mktemp -d)"
    lein with-profiles +native-image deps

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    find $out -type f \
      -name \*.lastUpdated -or \
      -name resolver-status.properties -or \
      -name _remote.repositories \
      -delete

    runHook postInstall
  '';

  dontFixup = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-aWZPsJF32ENyYNZCHf5amxVF9pb+5M73JqG/OITZlak=";
}
