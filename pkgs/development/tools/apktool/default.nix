{ stdenv, fetchurl, makeWrapper, jre, build-tools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "2.3.4";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    sha256 = "07fwp5sczyivdz37ag9fa258gr9jbz3k3395hp5db7cwizaip2vm";
  };

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    install -D ${src} "$out/libexec/apktool/apktool.jar"
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
        --add-flags "-jar $out/libexec/apktool/apktool.jar" \
        --prefix PATH : "${builtins.head build-tools}/libexec/android-sdk/build-tools/28.0.3"
  '';

  meta = with stdenv.lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = https://ibotpeaches.github.io/Apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
