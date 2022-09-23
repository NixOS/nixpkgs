{ lib, stdenv, fetchurl }:
stdenv.mkDerivation rec {
  pname = "psftools";
  version = "1.1.1";
  src = fetchurl {
    url = "https://www.seasip.info/Unix/PSF/${pname}-${version}.tar.gz";
    sha256 = "sha256-MecY4JsIXTgHdkrFkQ+C3fC6OEFRUgjUgf7qxfKeZtM=";
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
