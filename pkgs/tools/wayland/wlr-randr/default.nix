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
  version = "0.3.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u5fsM+DCefPTXEg+ByTs0wyOlEfCj5OUeJydX6RRvo4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [ wayland ];

  meta = with lib; {
    description = "An xrandr clone for wlroots compositors";
    homepage = "https://git.sr.ht/~emersion/wlr-randr";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
    mainProgram = "wlr-randr";
  };
}
