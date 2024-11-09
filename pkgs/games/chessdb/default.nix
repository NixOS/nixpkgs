{ lib, stdenv, fetchurl, tcl, tk, libX11, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "chessdb";
  version = "3.6.19-beta-1";

  src = fetchurl {
    url = "mirror://sourceforge/chessdb/ChessDB-${version}.tar.gz";
    sha256 = "0brc3wln3bxp979iqj2w1zxpfd0pch8zzazhdmwf7acww4hrsz62";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tcl tk libX11 ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SHAREDIR=$(out)/share/chessdb"
    "SOUNDSDIR=$(out)/share/chessdb/sounds"
    "TBDIR=$(out)/share/chessdb/tablebases"
    "MANDIR=$(out)/man"
  ];

  meta = {
    homepage = "https://chessdb.sourceforge.net/";
    description = "Free chess database";
    platforms = lib.platforms.linux;
  };
}
