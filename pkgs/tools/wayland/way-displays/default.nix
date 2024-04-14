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
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = version;
    sha256 = "sha256-OEsRSmtNDt3MO5MO7Ch9mOHHHraN+9qfcFn2AhXfvpk=";
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

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PREFIX_ETC=${placeholder "out"}"
    "CC:=$(CC)"
    "CXX:=$(CXX)"
  ];

  meta = with lib; {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = licenses.mit;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
    mainProgram = "way-displays";
  };
}
