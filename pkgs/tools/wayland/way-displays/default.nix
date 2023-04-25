{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wayland-scanner
, wayland
, libinput
, yaml-cpp
}:

stdenv.mkDerivation rec {
  pname = "way-displays";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = "${version}";
    sha256 = "sha256-o8fju0EQy2KS5yxe9DP3A8ewYgA2GzJtMY41BGJUZis=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    yaml-cpp
    libinput
  ];

  makeFlags = [ "DESTDIR=$(out) PREFIX= PREFIX_ETC= ROOT_ETC=$(out)/etc"];

  meta = with lib; {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = licenses.mit;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
  };
}
