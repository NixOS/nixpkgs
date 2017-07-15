{ stdenv, cmake, fetchFromGitHub, hidapi, libusb1, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "refs/tags/v${version}";
    sha256 = "0qnpiyz22xdsz1ajysxsb07s8n4h8qhljxg1kk60365irjs9affz";
  };

  buildInputs = [
    hidapi
    libusb1
    qt5.qtbase
    qt5.qttranslations
  ];
  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  cmakeFlags = "-DHAVE_LIBAPPINDICATOR=NO";

  meta = with stdenv.lib; {
    description      = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription  = ''
       The nitrokey-app provides a QT system tray widget with wich you can
       access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
       See https://www.nitrokey.com/ for more information.
    '';
    homepage         = https://github.com/Nitrokey/nitrokey-app;
    repositories.git = https://github.com/Nitrokey/nitrokey-app.git;
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ kaiha fpletz ];
  };
}
