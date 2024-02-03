{ lib
, stdenv
, fetchurl
, autoreconfHook
, pkg-config
, glib
, i2c-tools
, udev
, kmod
, libgudev
, libusb1
, libdrm
, xorg
}:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "1.4.2";

  src = fetchurl {
    url = "https://www.ddcutil.com/tarballs/ddcutil-${version}.tar.gz";
    hash = "sha256-wGwTZheRHi5pGf6WB9hGd8m/pLOmnlYYrS5dd+QItAQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    glib
    i2c-tools
    kmod
    libdrm
    libgudev
    libusb1
    udev
    xorg.libXrandr
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
    changelog = "https://github.com/rockowitz/ddcutil/blob/v${version}/CHANGELOG.md";
  };
}

