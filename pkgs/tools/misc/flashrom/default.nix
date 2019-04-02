{ lib, stdenv, fetchurl, pkgconfig, libftdi, pciutils }:

stdenv.mkDerivation rec {
  name = "flashrom-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    sha256 = "0i6yrrl69hrqmwd7azj7x3j46m0qpvzmk3b5basym7mnlpfzhyfm";
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
