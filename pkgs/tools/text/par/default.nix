{stdenv, fetchurl, fetchpatch}:

stdenv.mkDerivation {
  name = "par-1.52";

  src = fetchurl {
    url = http://www.nicemice.net/par/Par152.tar.gz;
    sha256 = "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082";
  };

  patches = [
    # A patch by Jérôme Pouiller that adds support for multibyte
    # charsets (like UTF-8), plus Debian packaging.
    (fetchpatch {
      url = "http://sysmic.org/dl/par/par-1.52-i18n.4.patch";
      sha256 = "0alw44lf511jmr38jnh4j0mpp7vclgy0grkxzqf7q158vzdb6g23";
    })
  ];

  buildPhase = ''make -f protoMakefile'';

  installPhase = ''
    mkdir -p $out/bin
    cp par $out/bin

    mkdir -p $out/share/man/man1
    cp  par.1 $out/share/man/man1
  '';


  meta = {
    homepage = http://www.nicemice.net/par/;
    description = "Paragraph reflow for email";
    platforms = stdenv.lib.platforms.unix;
  };
}
