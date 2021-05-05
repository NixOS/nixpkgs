{ lib
, stdenv
, fetchurl
, pkg-config, which
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "minipro";
  version = "0.5";

  src = fetchurl {
    url = "https://gitlab.com/DavidGriffith/minipro/-/archive/master/minipro-${version}.tar.bz2";
    sha256 = "sha256-ewLW4PxZaXHfNVyY9xJHcAxGcTL9YejOCIa32xhmSj4=";
  };

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ libusb1 ];

  makeFlags = [
    "PREFIX=/"
    "DESTDIR=${placeholder "out"}"
    "UDEV_RULES_INSTDIR=${placeholder "out"}/lib/udev/rules.d" "UDEV_DIR=/"
  ]; 

  meta = with lib; {
    homepage = "https://gitlab.com/DavidGriffith/minipro/";
    description = "An open source program for controlling the MiniPRO TL866xx series of chip programmers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ baloo ];
    platforms = platforms.all;
  };
}
