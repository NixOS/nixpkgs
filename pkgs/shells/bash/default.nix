{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bash-3.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/bash/bash-3.2.tar.gz;
    md5 = "00bfa16d58e034e3c2aa27f390390d30";
  };

  patches = [./winsize.patch];

  meta = {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
  };
}
