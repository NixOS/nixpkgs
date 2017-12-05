{ stdenv, fetchurl, makeWrapper, jre, buildTools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "2.2.4";

  src = fetchurl {
    url = "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar";
    sha256 = "0l9jxa393a52iiawh93v31vr1y6z2bwg6dqhpivqd6y0vip1h7qz";
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
    homepage    = https://code.google.com/p/android-apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
