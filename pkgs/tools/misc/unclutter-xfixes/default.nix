{ stdenv, fetchFromGitHub,
  xlibsWrapper, libev, libXi, libXfixes,
  pkgconfig, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "unclutter-xfixes";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "unclutter-xfixes";
    rev = "v${version}";
    sha256 = "0anny6hvwf5nh7ghgi4gdcywhwyhgfvqvp7fjhm59kjc3qxnwf96";
  };

  nativeBuildInputs = [ pkgconfig asciidoc libxslt docbook_xsl ];
  buildInputs = [ xlibsWrapper libev libXi libXfixes ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Rewrite of unclutter using the X11 Xfixes extension";
    platforms = platforms.unix;
    license = stdenv.lib.licenses.mit;
    inherit version;
  };
}
