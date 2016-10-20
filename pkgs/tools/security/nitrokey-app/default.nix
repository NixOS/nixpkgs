{ stdenv, cmake, fetchFromGitHub, libappindicator-gtk2, libnotify, libusb1, pkgconfig
, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    sha256 = "0h131847pllsr7rk7nn8vlj74byb5f14cl9h3g3pmlq5zj8ylfkx";
  };

  buildInputs = [
    cmake
    libappindicator-gtk2
    libnotify
    libusb1
    pkgconfig
    qt5.qtbase
  ];
  patches = [
     ./FixInstallDestination.patch
     ./HeaderPath.patch
  ];
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
