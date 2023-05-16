<<<<<<< HEAD
{ lib, stdenvNoCC, fetchurl, makeBinaryWrapper, jre }:

stdenvNoCC.mkDerivation rec {
  version = "10.12.3";
=======
{ lib, stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "10.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "checkstyle";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
<<<<<<< HEAD
    sha256 = "sha256-drJO3sZlh2G9f80cvPD41YjhHZt74lmV9bSIhUDrTKo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
=======
    sha256 = "sha256-Fw8sG3iAnFXbdzGgbDJEoGGGdd+dSxCrS4KTLunEyjA=";
  };

  nativeBuildInputs = [ makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/checkstyle/checkstyle-all.jar
    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/checkstyle/checkstyle-all.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Checks Java source against a coding standard";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
<<<<<<< HEAD
    homepage = "https://checkstyle.org/";
    changelog = "https://checkstyle.org/releasenotes.html#Release_${version}";
=======
    homepage = "http://checkstyle.sourceforge.net/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pSub ];
    platforms = jre.meta.platforms;
  };
}
