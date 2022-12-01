{ lib
, stdenv
, fetchFromGitHub

, meson
, ninja
, pkg-config

, libxkbcommon
, wayland
}:

stdenv.mkDerivation rec {
  pname = "wtype";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wtype";
    rev = "v${version}";
    hash = "sha256-TfpzAi0mkXugQn70MISyNFOXIJpDwvgh3enGv0Xq8S4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland ];
  buildInputs = [ libxkbcommon wayland ];

  meta = with lib; {
    description = "xdotool type for wayland";
    homepage = "https://github.com/atx/wtype";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
