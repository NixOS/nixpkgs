{ stdenv, cmake, fetchgit, hidapi, libusb1, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "1.1";

  src = fetchgit {
    url = "https://github.com/Nitrokey/nitrokey-app.git";
    rev = "refs/tags/v${version}";
    sha256 = "11pz1p5qgghkr5f8s2wg34zqhxk2vq465i73w1h479j88x35rdp0";
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
