{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
}:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JeSxFXSFxcTwJz9EaLb18wtD4ZIT+ATeYM5OyDTJhDQ=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ wayland ];

  meta = with lib; {
    description = "An xrandr clone for wlroots compositors";
    homepage = "https://github.com/emersion/wlr-randr";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
  };
}
