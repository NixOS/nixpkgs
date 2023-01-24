{ lib, stdenv, fetchurl, validatePkgConfig, libiconv }:

stdenv.mkDerivation rec {
  pname = "freexl";
  version = "1.0.6";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/freexl-${version}.tar.gz";
    hash = "sha256-Pei1ej0TDLKIHqUtOqnOH+7bG1e32qTrN/dRQE+Q/CI=";
  };

  nativeBuildInputs = [ validatePkgConfig ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A library to extract valid data from within an Excel (.xls) spreadsheet";
    homepage = "https://www.gaia-gis.it/fossil/freexl";
    # They allow any of these
    license = with licenses; [ gpl2Plus lgpl21Plus mpl11 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
