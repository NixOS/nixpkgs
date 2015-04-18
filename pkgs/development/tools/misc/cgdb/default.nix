{ stdenv, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "cgdb-${version}";
  version = "0.6.7";

  src = fetchurl {
    url = "http://cgdb.me/files/${name}.tar.gz";
    sha256 = "1agxk6a97v6q0n097zw57qqpaza4j79jg36x99bh8yl23qfx6kh7";
  };

  buildInputs = [ ncurses readline ];

  meta = {
    description = "A curses interface to gdb";

    homepage = https://cgdb.github.io/;

    repositories.git = git://github.com/cgdb/cgdb.git;

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = with stdenv.lib.platforms; linux ++ cygwin;
    maintainers = with stdenv.lib.maintainers; [ viric ];
  };
}
