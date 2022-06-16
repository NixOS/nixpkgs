{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wayland
, libinput
, libyamlcpp
}:

stdenv.mkDerivation rec {
  pname = "way-displays";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = "${version}";
    sha256 = "sha256-5A0qZRpWw3Deo9cGqGULpQMoPCVh85cWE/wJ5XSbVJk=";
  };

  postPatch = ''
    substituteInPlace src/cfg.cpp --replace "\"/etc" "\"$out/etc"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland
  ];

  buildInputs = [
    wayland
    libyamlcpp
    libinput
  ];

  makeFlags = [ "DESTDIR=$(out) PREFIX= PREFIX_ETC="];

  meta = with lib; {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = licenses.mit;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
  };
}
