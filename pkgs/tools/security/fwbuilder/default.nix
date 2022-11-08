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

  postPatch = ''
    # Avoid blanket -Werror as it triggers on any minor compiler
    # warnings like deprecated functions or invalid indentat8ion.
    # Leave fixing these problems to upstream.
    substituteInPlace CMakeLists.txt --replace ';-Werror;' ';'
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    qtwayland
  ];

  meta = with lib; {
    description = "GUI Firewall Management Application";
    homepage    = "https://github.com/fwbuilder/fwbuilder";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = [ maintainers.elatov ];
  };
}
