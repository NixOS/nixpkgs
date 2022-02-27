{ lib, stdenv, fetchurl, makeWrapper, jre, build-tools }:

stdenv.mkDerivation rec {
  pname = "apktool";
  version = "2.6.1";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    sha256 = "sha256-vCuah6xahpBbbKNDwhoNs7w3vdURVLyc32VSPZWJXTQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase =
    let
      tools = builtins.head build-tools;
    in ''
      install -D ${src} "$out/libexec/apktool/apktool.jar"
      mkdir -p "$out/bin"
      makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
          --add-flags "-jar $out/libexec/apktool/apktool.jar" \
          --prefix PATH : "${tools}/libexec/android-sdk/build-tools/${tools.version}"
    '';

  meta = with lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = "https://ibotpeaches.github.io/Apktool/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
