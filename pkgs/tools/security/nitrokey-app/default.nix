{ stdenv, cmake, fetchFromGitHub, libusb1, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    sha256 = "1l5l4lwxmyd3jrafw19g12sfc42nd43sv7h7i4krqxnkk6gfx11q";
  };

  buildInputs = [
    libusb1
    qt5.qtbase
  ];
  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  patches = [
     ./FixInstallDestination.patch
     ./HeaderPath.patch
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
    maintainer       = maintainers.kaiha;
  };
}
