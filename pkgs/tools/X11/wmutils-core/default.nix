{ lib, stdenv, fetchFromGitHub, libxcb, xcbutil, xcb-util-cursor }:

stdenv.mkDerivation rec {
  pname = "wmutils-core";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "core";
    rev = "v${version}";
    sha256 = "sha256-Nv8ZTi3qVQyOkwyErjtE6/lLCubcLM2BRTY48r1HhHo=";
  };

  buildInputs = [ libxcb xcbutil xcb-util-cursor ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Set of window manipulation tools";
    homepage = "https://github.com/wmutils/core";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
