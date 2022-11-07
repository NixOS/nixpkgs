{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
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
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    qtwayland
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=misleading-indentation"
    "-Wno-error=deprecated-declarations"
  ];

  meta = with lib; {
    description = "GUI Firewall Management Application";
    longDescription = ''
      Firewall Builder is a GUI firewall management application for iptables,
      PF, Cisco ASA/PIX/FWSM, Cisco router ACL and more. Firewall configuration
      data is stored in a central file that can scale to hundreds of firewalls
      managed from a single UI.
    '';
    homepage = "https://github.com/fwbuilder/fwbuilder";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.elatov ];
  };
}
