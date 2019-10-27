{ fetchurl, stdenv, gcj, unzip }:

stdenv.mkDerivation {
  name = "pdftk-2.02";

  src = fetchurl {
    url = "https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-src.zip";
    sha256 = "1hdq6zm2dx2f9h7bjrp6a1hfa1ywgkwydp14i2sszjiszljnm3qi";
  };

  nativeBuildInputs = [ gcj unzip ];

  hardeningDisable = [ "fortify" "format" ];

  preBuild = ''
    cd pdftk
    sed -e 's@/usr/bin/@@g' -i Makefile.*
    NIX_ENFORCE_PURITY= \
      make \
      LIBGCJ="${gcj.cc}/share/java/libgcj-${gcj.cc.version}.jar" \
      GCJ=gcj GCJH=gcjh GJAR=gjar \
      -iC ../java all
  '';

  # Makefile.Debian has almost fitting defaults
  makeFlags = [ "-f" "Makefile.Debian" "VERSUFF=" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp pdftk $out/bin
    cp ../pdftk.1 $out/share/man/man1
  '';


  meta = {
    description = "Simple tool for doing everyday things with PDF documents";
    homepage = https://www.pdflabs.com/tools/pdftk-server/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = with stdenv.lib.platforms; linux;
  };
}
