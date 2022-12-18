{ lib, stdenv, fetchFromGitHub,
  libev, libX11, libXext, libXi, libXfixes,
  pkg-config, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "unclutter-xfixes";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "unclutter-xfixes";
    rev = "v${version}";
    sha256 = "sha256-suKmaoJq0PBHZc7NzBQ60JGwJkAtWmvzPtTHWOPJEdc=";
  };

  nativeBuildInputs = [ pkg-config asciidoc libxslt docbook_xsl ];
  buildInputs = [ libev libX11 libXext libXi libXfixes ];

  prePatch = ''
    substituteInPlace Makefile --replace 'PKG_CONFIG =' 'PKG_CONFIG ?='
  '';
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Rewrite of unclutter using the X11 Xfixes extension";
    platforms = platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ maintainers.globin ];
    mainProgram = "unclutter";
  };
}
