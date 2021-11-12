{ lib, stdenv, fetchFromGitHub, libxcb, xcbutil, xcb-util-cursor }:

stdenv.mkDerivation rec {
  pname = "wmutils-core";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "core";
    rev = "v${version}";
    sha256 = "XPVH7vXlpmUsvNyGKMxLSZnWLnH/J5nGkXizcVqDwzM=";
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
