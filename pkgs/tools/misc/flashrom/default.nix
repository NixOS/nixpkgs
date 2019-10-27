{ lib, stdenv, fetchurl, pkgconfig, libftdi, pciutils }:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.1";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    sha256 = "06afq680n9p34hi3vrkn12vd1pfyq2062db9qqbi4hi21k3skbdf";
  };

  # Newer versions of libusb deprecate some API flashrom uses.
  #postPatch = ''
  #  substituteInPlace Makefile \
  #    --replace "-Werror" "-Werror -Wno-error=deprecated-declarations -Wno-error=unused-const-variable="
  #'';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libftdi pciutils ];

  preConfigure = "export PREFIX=$out";

  meta = with lib; {
    homepage = http://www.flashrom.org;
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2;
    maintainers = with maintainers; [ funfunctor fpletz ];
    platforms = with platforms; linux;
  };
}
