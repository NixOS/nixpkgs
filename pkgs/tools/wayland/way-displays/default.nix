{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wayland
, libinput
, yaml-cpp
}:

stdenv.mkDerivation rec {
  pname = "way-displays";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = version;
    sha256 = "sha256-X+/aM+/2pO1FbHGwEiC2w9AxPXHf1EVZkyr+CXtprLk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland
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
    mainProgram = "way-displays";
  };
}
