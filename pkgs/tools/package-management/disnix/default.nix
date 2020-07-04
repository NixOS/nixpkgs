{ stdenv, fetchFromGitHub, pkgconfig, glib, libxml2, libxslt, getopt, gettext, nixUnstable, dysnomia, libintl, libiconv, help2man, doclifter, docbook5, dblatex, doxygen, docbook5_xsl, libnixxml, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "disnix-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "disnix";
    rev = "f31ffc8d7d1bbeb197c6b4643d35ce300cf8e87a";
    sha256 = "sha256-IBDPXM+put9h2aUbxS6TlBeLmautQ8aVPI/jjJjoo+M=";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook help2man doclifter docbook5 dblatex doxygen docbook5_xsl ];
  buildInputs = [ glib libxml2 libxslt getopt gettext nixUnstable libintl libiconv dysnomia libnixxml ];
  postPatch = ''
    ./bootstrap
  '';
  configureFlags = ''
    --with-docbook-rng=${docbook5}/xml/rng/docbook
    --with-docbook-xsl=${docbook5_xsl}/xml/xsl/docbook
  '';

  preConfigure = ''
    # TeX needs a writable font cache.
    export VARTEXFONTS=$TMPDIR/texfonts
  '';

  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with stdenv.lib.maintainers; [ sander tomberek ];
    platforms = stdenv.lib.platforms.unix;
  };
}
