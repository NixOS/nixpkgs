{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, glib, i2c-tools, udev, libgudev, libusb1, libdrm, xorg }:

stdenv.mkDerivation rec {
  pname = "ddcutil";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner  = "rockowitz";
    repo   = "ddcutil";
    rev    = "v${version}";
    sha256 = "1r89cfw3ycqwvpfwwiqg8ykc1vyr1gf3ah30mvrmmalgmi6bnx5w";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [
    i2c-tools udev libgudev
    glib libusb1 libdrm xorg.libXrandr
  ];

  meta = with stdenv.lib; {
    homepage    = "http://www.ddcutil.com/";
    description = "Query and change Linux monitor settings using DDC/CI and USB";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}

