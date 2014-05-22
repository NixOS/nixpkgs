{ stdenv, fetchurl, makeWrapper, jre, buildTools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "1.5.2";

  src = fetchurl {
    url = "https://android-apktool.googlecode.com/files/apktool${version}.tar.bz2";
    sha1 = "2dd828cf79467730c7406aa918f1da1bd21aaec8";
  };

  unpackCmd = ''
    tar -xvf $src || true
    cd apktool*
  '';

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D apktool.jar "$out/libexec/apktool/apktool.jar"
    ensureDir "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
        --add-flags "-jar $out/libexec/apktool/apktool.jar" \
        --prefix PATH : "${buildTools}/build-tools/android-4.3/"
  '';

  meta = with stdenv.lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = https://code.google.com/p/android-apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
  };

}
