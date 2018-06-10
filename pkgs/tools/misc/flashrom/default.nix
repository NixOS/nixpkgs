{ lib, stdenv, fetchurl, pkgconfig, libftdi, pciutils }:

let version = "1.0"; in
stdenv.mkDerivation rec {
  name = "flashrom-${version}";

  src = fetchurl {
    url = "http://download.flashrom.org/releases/${name}.tar.bz2";
    sha256 = "0i9wg1lyfg99bld7d00zqjm9f0lk6m0q3h3n9c195c9yysq5ccfb";
  };

  # Newer versions of libusb deprecate some API flashrom uses.
  postPatch = ''
    substituteInPlace Makefile \
      --replace "-Werror" "-Werror -Wno-error=deprecated-declarations -Wno-error=unused-const-variable="
  '';

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
