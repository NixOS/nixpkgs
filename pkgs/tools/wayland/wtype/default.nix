{ lib
, stdenv
, fetchFromGitHub

, meson
, ninja
, pkg-config

, libxkbcommon
, wayland
}:

stdenv.mkDerivation {
  pname = "wtype";
  version = "2020-09-14";

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wtype";
    rev = "74071228dea4047157ae82960a2541ecc431e4a1";
    sha256 = "1ncspxpnbwv1vkfmxs58q7aykjb6skaa1pg5sw5h798pss5j80rd";
  };

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
