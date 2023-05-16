<<<<<<< HEAD
{ lib
, stdenvNoCC
, fetchurl
, jdk
, makeWrapper
, callPackage
}:

assert jdk != null;

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apache-maven";
  version = "3.9.4";

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${finalAttrs.version}/binaries/${finalAttrs.pname}-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-/2a3DIMKONMx1E9sJaN7WCRx3vmhYck5ArrHvqMJgxk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/maven
    cp -r ${finalAttrs.pname}-${finalAttrs.version}/* $out/maven

    makeWrapper $out/maven/bin/mvn $out/bin/mvn \
      --set-default JAVA_HOME "${jdk}"
    makeWrapper $out/maven/bin/mvnDebug $out/bin/mvnDebug \
      --set-default JAVA_HOME "${jdk}"

    runHook postInstall
  '';

  passthru.buildMavenPackage = callPackage ./build-package.nix {
    maven = finalAttrs.finalPackage;
  };

  meta = with lib; {
    mainProgram = "mvn";
=======
{ lib, stdenv, fetchurl, jdk, makeWrapper }:

assert jdk != null;

stdenv.mkDerivation rec {
  pname = "apache-maven";
  version = "3.8.6";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://apache/maven/maven-3/${version}/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-xwR6SN62Jqvyb3GrNkPSltubHmfx+qfZiGN96sh2tak=";
  };

  nativeBuildInputs = [ makeWrapper ];

  inherit jdk;

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Build automation tool (used primarily for Java projects)";
    homepage = "https://maven.apache.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cko ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
