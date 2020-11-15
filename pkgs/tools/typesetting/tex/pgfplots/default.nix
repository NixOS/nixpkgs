{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "pgfplots-1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/pgfplots/pgfplots_1.5.1.tds.zip";
    sha256 = "1xajrmq35i0qlsfwydy5zzg6f1jg88hqqh5b3xsmglzrarnllbdi";
  };

  buildInputs = [ unzip ];

  unpackPhase = "unzip $src";

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = with stdenv.lib; {
    description = "TeX package to draw plots directly in TeX in two and three dimensions";
    homepage = "http://pgfplots.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
