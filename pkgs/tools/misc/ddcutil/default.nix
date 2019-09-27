{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, glib, i2c-tools, udev, libgudev, libusb, libdrm, xorg }:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "1p99kxgg2893ppp56q5igpva39lzj4wvx37c993r4p6i4gq6bi3v";
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
    platforms   = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}

