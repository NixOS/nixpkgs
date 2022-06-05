{ lib, stdenv, fetchurl, gsl
, dieharder, testers }:

stdenv.mkDerivation rec {
  pname = "dieharder";
  version = "3.31.1";

  src = fetchurl {
    url = "http://webhome.phy.duke.edu/~rgb/General/dieharder/dieharder-${version}.tgz";
    hash = "sha256-bP8P+DlMVTVJrHQzNZzPyVX7JnlCYDFGIN+l5M1Lcn8=";
  };

  patches = [
    # Include missing stdint.h header
    ./stdint.patch
  ];

  buildInputs = [ gsl ];

  passthru = {
    tests.version = testers.testVersion { package = dieharder; };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A Random Number Generator test suite";
    homepage = "https://webhome.phy.duke.edu/~rgb/General/dieharder.php";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.unix;
  };
}
