{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "procps-3.2.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.8.tar.gz;
    sha256 = "0d8mki0q4yamnkk4533kx8mc0jd879573srxhg6r2fs3lkc6iv8i";
  };
  patches = [./makefile.patch ./procps-build.patch ./gnumake3.82.patch];
  buildInputs = [ncurses];
}
