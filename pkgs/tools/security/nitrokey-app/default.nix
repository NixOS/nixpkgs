{ stdenv, cmake, fetchgit, hidapi, libusb1, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "nitrokey-app";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/Nitrokey/nitrokey-app.git";
    rev = "refs/tags/v${version}";
    sha256 = "0i910d1xrl4bfrg5ifkj3w4dp31igaxncy2yf97y4rsc8094bcb1";
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
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace 'DESTINATION ''${UDEV_MAIN_DIR}' 'DESTINATION lib/udev/rules.d'
    substituteInPlace data/41-nitrokey.rules --replace 'plugdev' 'wheel'
    '';
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
