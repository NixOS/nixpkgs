{ stdenv, fetchurl, makeWrapper, jre, buildTools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "2.3.3";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    sha256 = "1wjpn1wxg8fid2mch5ili35xqvasa3pk8h1xaiygw5idpxh3cm0f";
  };

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    install -D ${src} "$out/libexec/apktool/apktool.jar"
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
        --add-flags "-jar $out/libexec/apktool/apktool.jar" \
        --prefix PATH : "${buildTools}/build-tools/25.0.1/"
  '';

  meta = with stdenv.lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = https://ibotpeaches.github.io/Apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
