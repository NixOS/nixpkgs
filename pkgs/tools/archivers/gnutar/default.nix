{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.16";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/tar/tar-1.16.tar.bz2;
    md5 = "d6fe544e834a8f9db6e6c7c2d38ec100";
  };
}
