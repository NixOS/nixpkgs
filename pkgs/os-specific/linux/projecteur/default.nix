{ lib, mkDerivation, fetchFromGitHub,
  cmake, pkg-config,
  qtbase, qtgraphicaleffects, wrapQtAppsHook }:
mkDerivation rec {
  pname = "projecteur";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "jahnf";
    repo = "Projecteur";
    rev = "v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-kg6oYtJ4H5A6RNATBg+XvMfCb9FlhEBFjfxamGosMQg=";
  };

  postPatch = ''
    sed '1i#include <array>' -i src/device.h # gcc12
  '';

  buildInputs = [ qtbase qtgraphicaleffects ];
  nativeBuildInputs = [ wrapQtAppsHook cmake pkg-config ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX:PATH=${placeholder "out"}"
    "-DPACKAGE_TARGETS=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = with lib; {
    description = "Linux/X11 application for the Logitech Spotlight device (and similar devices).";
    homepage = "https://github.com/jahnf/Projecteur";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ benneti ];
  };
}
