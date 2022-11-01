{ lib, stdenv, fetchFromGitHub, jre, makeWrapper, maven }:

let
  pname = "jd-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "intoolswetrust";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-rRttA5H0A0c44loBzbKH7Waoted3IsOgxGCD2VM0U/Q=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;

    nativeBuildInputs = [ maven ];
    buildPhase = ''
      mvn package -Dmaven.repo.local=$out
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';

    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-5d3ZLuzoEkPjh01uL/BuhJ6kevLdsm1P4PMLkEWaVUM=";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ maven makeWrapper ];

  buildPhase = ''
    mvn --offline -Dmaven.repo.local=${deps} package;
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/jd-cli
    install -Dm644 jd-cli/target/jd-cli.jar $out/share/jd-cli

    makeWrapper ${jre}/bin/java $out/bin/jd-cli \
      --add-flags "-jar $out/share/jd-cli/jd-cli.jar"
  '';

  meta = with lib; {
    description = "Simple command line wrapper around JD Core Java Decompiler project";
    homepage = "https://github.com/intoolswetrust/jd-cli";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ majiir ];
  };
}
