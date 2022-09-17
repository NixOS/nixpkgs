{ lib
, stdenv
, fetchFromGitHub
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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rockowitz";
    repo = "ddcutil";
    rev = "v${version}";
    sha256 = "sha256-Di/feEQOHNhU3y/HwXQoOnu+gPQYP2Oedf1CPt8gHJ0=";
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
  };
}

