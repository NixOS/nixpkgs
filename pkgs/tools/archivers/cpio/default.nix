{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cpio-2.7";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/cpio/cpio-2.7.tar.bz2;
    md5 = "69ad6cb3d288aafe5f969f68d9fd0fb7";
  };
  patches = [./symlink.patch];
}
