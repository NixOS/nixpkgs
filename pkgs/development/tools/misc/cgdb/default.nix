{ stdenv, fetchurl, ncurses, readline }:

stdenv.mkDerivation rec {
  name = "cgdb-0.6.6";

  src = fetchurl {
    url = "mirror://sourceforge/cgdb/${name}.tar.gz";
    sha256 = "0iap84ikpk1h58wy14zzi1kwszv1hsnvpvnz14swkz54yrh9z7ng";
  };

  buildInputs = [ ncurses readline ];

  meta = {
    description = "A curses interface to gdb";

    homepage = http://cgdb.sourceforge.net/;

    repositories.git = git://github.com/cgdb/cgdb.git;

    license = "GPLv2+";

    platforms = with stdenv.lib.platforms; linux ++ cygwin;
    maintainers = with stdenv.lib.maintainers; [ viric ];
  };
}
