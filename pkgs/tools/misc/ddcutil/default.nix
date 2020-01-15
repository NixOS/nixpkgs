{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, glib, i2c-tools, udev, libgudev, libusb, libdrm, xorg }:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "1mqamwafm0rhw420i0pib6gq6hkdafnbg07b0z2ckrxii44sy0c2";
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

