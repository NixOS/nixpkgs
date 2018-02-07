{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, glib, i2c-tools, udev, libgudev, libusb, libdrm, xorg }:

stdenv.mkDerivation rec {
  name = "ddcutil-${version}";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "127a5v545gvfgxqqjxqafsg1p8i4qd5wnpdwccr38jbsphl6yzl4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    i2c-tools udev libgudev
    glib libusb libdrm xorg.libXrandr
  ];

  meta = with stdenv.lib; {
    homepage    = http://www.ddcutil.com/;
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}

