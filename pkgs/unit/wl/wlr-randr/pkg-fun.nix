{ lib
, stdenv
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, wayland
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JeSxFXSFxcTwJz9EaLb18wtD4ZIT+ATeYM5OyDTJhDQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ wayland ];

  meta = with lib; {
    description = "An xrandr clone for wlroots compositors";
    homepage = "https://git.sr.ht/~emersion/wlr-randr";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
