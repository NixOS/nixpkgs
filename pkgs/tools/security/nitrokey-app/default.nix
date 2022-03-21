{ lib, stdenv, bash-completion, cmake, fetchFromGitHub, hidapi, libusb1, pkg-config
, qtbase, qttranslations, qtsvg, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "nitrokey-app";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    sha256 = "1k0w921hfrya4q2r7bqn7kgmwvwb7c15k9ymlbnksmfc9yyjyfcv";
    fetchSubmodules = true;
  };

  buildInputs = [
    bash-completion
    hidapi
    libusb1
    qtbase
    qttranslations
    qtsvg
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = with lib; {
    description      = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription  = ''
       The nitrokey-app provides a QT system tray widget with which you can
       access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
       See https://www.nitrokey.com/ for more information.
    '';
    homepage         = "https://github.com/Nitrokey/nitrokey-app";
    repositories.git = "https://github.com/Nitrokey/nitrokey-app.git";
    license          = licenses.gpl3;
    maintainers      = with maintainers; [ kaiha fpletz ];
  };
}
