{ lib, stdenv, fetchFromGitHub,
  xlibsWrapper, libev, libXi, libXfixes,
  pkg-config, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "unclutter-xfixes";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "unclutter-xfixes";
    rev = "v${version}";
    sha256 = "148m4wx8v57s3l2wb69y9imb00y8ca2li27hsxibwnl1wrkb7z4b";
  };

  nativeBuildInputs = [ pkg-config asciidoc libxslt docbook_xsl ];
  buildInputs = [ xlibsWrapper libev libXi libXfixes ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Rewrite of unclutter using the X11 Xfixes extension";
    platforms = platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ maintainers.globin ];
  };
}
