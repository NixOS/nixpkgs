{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "usbview";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "gregkh";
    repo = "usbview";
    rev = "v${version}";
    sha256 = "1cw5jjpidjn34rxdjslpdlj99k4dqaq1kz6mplv5hgjdddijvn5p";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk3
  ];

  meta = with lib; {
    description = "USB viewer for Linux";
    license = licenses.gpl2Only;
    homepage = "http://www.kroah.com/linux-usb/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
