{ lib
, stdenv
, fetchFromGitHub
, asciidoc
, libxcb
, xcbutil
, xcbutilkeysyms
, xcbutilwm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxhkd";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "sxhkd";
    rev = finalAttrs.version;
    hash = "sha256-OelMqenk0tiWMLraekS/ggGf6IsXP7Sz7bv75NvnNvI=";
  };

  nativeBuildInputs = [
    asciidoc
  ];

  buildInputs = [
    libxcb
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vyp AndersonTorres ];
    platforms = platforms.linux;
  };
})
