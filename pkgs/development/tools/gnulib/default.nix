{ stdenv, fetchgit }:

stdenv.lib.setName "gnulib-0.0-7898-gdb9cad7" (fetchgit {
  url = "http://git.savannah.gnu.org/r/gnulib.git";
  rev = "db9cad7b8b59a010ff9158513a29cb002a2b8ae1";
  sha256 = "1azdz7mhx1jf0l17wn7zp591wxry0ys4g29ycij5mai7vzhddjn6";
})
