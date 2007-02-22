{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "gdb-6.6";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/gdb/gdb-6.6.tar.bz2;
    md5 = "a4df41d28dd514d64e8ccbfe125fd9a6";
  };
  buildInputs = [ncurses];
}
