{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "rman-3.2";

  src = fetchurl {
    url = mirror://sourceforge/polyglotman/3.2/rman-3.2.tar.gz;
    sha256 = "0prdld6nbkdlkcgc2r1zp13h2fh8r0mlwxx423dnc695ddlk18b8";
  };

  makeFlags = "BINDIR=$(out)/bin MANDIR=$(out)/share/man";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Parse formatted man pages and man page source from most flavors of UNIX and converts them to HTML, ASCII, TkMan, DocBook, and other formats";
    license = "artistic";
    platforms = stdenv.lib.platforms.linux;
  };
}
