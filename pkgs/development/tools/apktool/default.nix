{ stdenv, fetchurl, makeWrapper, jre, buildTools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "2.2.2";

  src = fetchurl {
    url = "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar";
    sha256 = "1a94jw0ml08xdwls1q9v5p1zak5qrbw2zyychnm5vch8znyws411";
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
