{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, glib, i2c-tools, udev, libgudev, libusb1, libdrm, xorg }:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "sha256-+HxezUWQHyL9r4QZkJyWzWnjquq/ux5W5j2B5prH8Fg=";
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

