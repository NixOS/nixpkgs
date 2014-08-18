{ fetchurl, stdenv, gcj }:

stdenv.mkDerivation {
  name = "pdftk-1.41";

  src = fetchurl {
    url = http://www.pdfhacks.com/pdftk/pdftk-1.41.tar.bz2;
    sha256 = "1vdrc3179slix6lz3gdiy53z7sh2yf9026r3xi6wdarwrcpawfrf";
  };

  patches = [ ./gcc-4.3.patch ./gcc-4.4.patch ];

  buildInputs = [ gcj ];

  makeFlags = [ "-f" "Makefile.Generic" ];

  preBuild = "cd pdftk";

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pdftk $out/bin
    cp ../debian/pdftk.1 $out/share/man/man1
  '';

  meta = {
    description = "Simple tool for doing everyday things with PDF documents";
    homepage = http://www.accesspdf.com/pdftk/;
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
