{lib, stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  pname = "pgfplots";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/pgfplots/pgfplots_${version}.tds.zip";
    sha256 = "1xajrmq35i0qlsfwydy5zzg6f1jg88hqqh5b3xsmglzrarnllbdi";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = "unzip $src";

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = with lib; {
    description = "TeX package to draw plots directly in TeX in two and three dimensions";
    homepage = "http://pgfplots.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
