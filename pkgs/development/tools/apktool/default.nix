<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk_headless
, aapt
}:

stdenv.mkDerivation rec {
  pname = "apktool";
  version = "2.8.1";
=======
{ lib, stdenv, fetchurl, makeWrapper, jre, build-tools }:

stdenv.mkDerivation rec {
  pname = "apktool";
  version = "2.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
<<<<<<< HEAD
    hash = "sha256-e0qOFwPiKNIG2ylkS3EUFofYoRG1WwObCLAt+kQ6sPk=";
=======
    sha256 = "sha256-wRtetRjZrCqxjpWcvgh0mQeQcrBNVnzcrlzrRH+afn0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase =
<<<<<<< HEAD
    ''
      install -D ${src} "$out/libexec/apktool/apktool.jar"
      mkdir -p "$out/bin"
      makeWrapper "${jdk_headless}/bin/java" "$out/bin/apktool" \
          --add-flags "-jar $out/libexec/apktool/apktool.jar" \
          --prefix PATH : ${lib.getBin aapt}
=======
    let
      tools = builtins.head build-tools;
    in ''
      install -D ${src} "$out/libexec/apktool/apktool.jar"
      mkdir -p "$out/bin"
      makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
          --add-flags "-jar $out/libexec/apktool/apktool.jar" \
          --prefix PATH : "${tools}/libexec/android-sdk/build-tools/${tools.version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';

  meta = with lib; {
    description = "A tool for reverse engineering Android apk files";
<<<<<<< HEAD
    homepage = "https://ibotpeaches.github.io/Apktool/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
=======
    homepage    = "https://ibotpeaches.github.io/Apktool/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
