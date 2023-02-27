{ lib, stdenv, fetchurl, lzip }:

stdenv.mkDerivation rec {
  pname = "lziprecover";
  version = "1.23";

  src = fetchurl {
    url = "mirror://savannah/lzip/lziprecover/${pname}-${version}.tar.gz";
    sha256 = "sha256-8pgEF38G3VHD+lJhWuGYp2ACts6Nlhw1dVRsN0D0tXI=";
  };

  configureFlags = [
    "CPPFLAGS=-DNDEBUG"
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = true;
  nativeCheckInputs = [ lzip ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/lziprecover.html";
    description = "Data recovery tool for lzip compressed files";
    license = lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ vlaci ];
    platforms = lib.platforms.all;
  };
}
