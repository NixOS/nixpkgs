{ stdenv, fetchurl, pkgconfig, libxml2, libxslt, popt, perl
, glib, pango, pangoxsl, gtk2, libtool, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "xmlroff-${version}";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/xmlroff/xmlroff/archive/v${version}.tar.gz";
    sha256 = "1sczn6xjczsfdxlbjqv4xqlki2a95y2s8ih2nl9v1vhqfk17fiww";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf
    automake
    libxml2
    libxslt
    libtool
    glib
    pango
    pangoxsl
    gtk2
    popt
  ];

  configureScript = "./autogen.sh";

  configureFlags = [
    "--disable-pangoxsl"
    "--disable-gp"
  ];

  hardeningDisable = [ "format" ];

  preBuild = ''
    substituteInPlace tools/insert-file-as-string.pl --replace "/usr/bin/perl" "${perl}/bin/perl"
    substituteInPlace Makefile --replace "docs" ""
  '';

  sourceRoot = "${name}/xmlroff/";

  patches = [./xmlroff.patch];

  meta = {
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
