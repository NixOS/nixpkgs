{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, wrapQtAppsHook
, wayland
, wayland-protocols
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "fwbuilder";
  version = "6.0.0-rc1";

  src = fetchFromGitHub {
    owner = "fwbuilder";
    repo = "fwbuilder";
    rev = "v${version}";
    hash = "sha256-j5HjGcIqq93Ca9OBqEgSotoSXyw+q6Fqxa3hKk1ctwQ=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    qtwayland
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=misleading-indentation"
  ];

  meta = with lib; {
    description = "GUI Firewall Management Application";
    homepage    = "https://github.com/fwbuilder/fwbuilder";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = [ maintainers.elatov ];
  };
}
