{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "psftools";
  version = "1.0.14";
  src = fetchurl {
    url = "https://www.seasip.info/Unix/PSF/${pname}-${version}.tar.gz";
    sha256 = "17nia5n5rabbh42gz51c8y53rjwddria4j3wvzk8dd0llj7k1y6w";
  };
  outputs = ["out" "man" "dev" "lib"];

  meta = with lib; {
    homepage = "https://www.seasip.info/Unix/PSF";
    description = "Conversion tools for .PSF fonts";
    longDescription = ''
      The PSFTOOLS are designed to manipulate fixed-width bitmap fonts,
      such as DOS or Linux console fonts. Both the PSF1 (8 pixels wide)
      and PSF2 (any width) formats are supported; the default output
      format is PSF2.
    '';
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kaction ];
  };
}
