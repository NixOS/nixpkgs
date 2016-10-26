{ stdenv, cmake, fetchFromGitHub, libusb1, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    sha256 = "0acb2502r3wa0mry6h8sz1k16zaa4bgnhxwxqd1vd1y42xc6g9bw";
  };

  buildInputs = [
    cmake
    libusb1
    pkgconfig
    qt5.qtbase
  ];
  patches = [
     ./FixInstallDestination.patch
     ./HeaderPath.patch
  ];
  cmakeFlags = "-DHAVE_LIBAPPINDICATOR=NO";
  meta = {
    description      = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription  = ''
       The nitrokey-app provides a QT system tray widget with wich you can
       access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
       See https://www.nitrokey.com/ for more information.
    '';
    homepage         = https://github.com/Nitrokey/nitrokey-app;
    repositories.git = https://github.com/Nitrokey/nitrokey-app.git;
    license          = stdenv.lib.licenses.gpl3;
    maintainer       = stdenv.lib.maintainers.kaiha;
  };
}
