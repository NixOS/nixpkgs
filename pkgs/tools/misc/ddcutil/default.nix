{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, glib, i2c-tools, udev, libgudev, libusb1, libdrm, xorg }:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "sha256-F/tKW81bAyYtwpxhl5XC8YyMB+6S0XmqqigwJY2WFDU=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    i2c-tools udev libgudev
    glib libusb1 libdrm xorg.libXrandr
  ];

  meta = with lib; {
    homepage    = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}

