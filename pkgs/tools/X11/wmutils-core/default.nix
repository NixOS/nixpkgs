{ lib, stdenv, fetchurl, libxcb, xcbutil, xcb-util-cursor }:

stdenv.mkDerivation rec {
  pname = "wmutils-core";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/wmutils/core/archive/v${version}.tar.gz";
    sha256 = "0wk39aq2lrnc0wjs8pv3cigw3lwy2qzaw0v61bwknd5wabm25bvj";
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
