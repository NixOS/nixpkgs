{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, glib, i2c-tools, udev, libgudev, libusb, libdrm, xorg }:

stdenv.mkDerivation rec {
  name = "ddcutil-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "0chs5bfw4yjnr7brhxxqydybcxdkjv4gnik2s0cvjzcj3bqnz73b";
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

