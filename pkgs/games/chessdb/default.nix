{ stdenv, fetchurl, tcl, tk, libX11, makeWrapper }:

stdenv.mkDerivation {
  name = "chessdb-3.6.19-beta-1";
  
  src = fetchurl {
    url = mirror://sourceforge/chessdb/ChessDB-3.6.19-beta-1.tar.gz;
    sha256 = "0brc3wln3bxp979iqj2w1zxpfd0pch8zzazhdmwf7acww4hrsz62";
  };

  buildInputs = [ tcl tk libX11 makeWrapper ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "SHAREDIR=$(out)/share/chessdb"
    "SOUNDSDIR=$(out)/share/chessdb/sounds"
    "TBDIR=$(out)/share/chessdb/tablebases"
    "MANDIR=$(out)/man"
  ];

  postInstall = ''
    wrapProgram $out/bin/chessdb --set TK_LIBRARY "${tk}/lib/${tk.libPrefix}"
  '';

  meta = {
    homepage = http://chessdb.sourceforge.net/;
    description = "ChessDB is a free chess database";
  };
}
