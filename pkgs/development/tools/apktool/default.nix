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

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    hash = "sha256-e0qOFwPiKNIG2ylkS3EUFofYoRG1WwObCLAt+kQ6sPk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase =
    ''
      install -D ${src} "$out/libexec/apktool/apktool.jar"
      mkdir -p "$out/bin"
      makeWrapper "${jdk_headless}/bin/java" "$out/bin/apktool" \
          --add-flags "-jar $out/libexec/apktool/apktool.jar" \
          --prefix PATH : ${lib.getBin aapt}
    '';

  meta = with lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage = "https://ibotpeaches.github.io/Apktool/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
