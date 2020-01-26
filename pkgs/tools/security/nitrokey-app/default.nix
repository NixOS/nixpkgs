{ stdenv, bash-completion, cmake, fetchFromGitHub, hidapi, libusb1, pkgconfig
, qtbase, qttranslations, qtsvg, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "nitrokey-app";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "v${version}";
    sha256 = "193kzlz3qn9il56h78faiqkgv749hdils1nn1iw6g3wphgx5fjs2";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace libnitrokey/CMakeLists.txt \
      --replace '/data/41-nitrokey.rules' '/libnitrokey/data/41-nitrokey.rules'
  '';

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
    pkgconfig
    wrapQtAppsHook
  ];
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

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
