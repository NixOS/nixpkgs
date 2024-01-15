{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "html2text";
  version = "1.3.2a";

  src = fetchurl {
    url = "http://www.mbayer.de/html2text/downloads/html2text-${version}.tar.gz";
    sha256 = "000b39d5d910b867ff7e087177b470a1e26e2819920dcffd5991c33f6d480392";
  };

  preConfigure = ''
    substituteInPlace configure \
        --replace /bin/echo echo \
        --replace CXX=unknown ':'
  '' + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace HTMLParser.C \
      --replace "register " ""
  '';

  # the --prefix has no effect
  installPhase = ''
    mkdir -p $out/bin $out/man/man{1,5}
    cp html2text $out/bin
    cp html2text.1.gz $out/man/man1
    cp html2textrc.5.gz $out/man/man5
  '';

  meta = {
    description = "Convert HTML to plain text";
    homepage = "http://www.mbayer.de/html2text/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eikek ];
  };
}
