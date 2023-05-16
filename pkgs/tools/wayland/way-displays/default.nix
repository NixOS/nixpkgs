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
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-X+/aM+/2pO1FbHGwEiC2w9AxPXHf1EVZkyr+CXtprLk=";
=======
    rev = "${version}";
    sha256 = "sha256-o8fju0EQy2KS5yxe9DP3A8ewYgA2GzJtMY41BGJUZis=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };
}
