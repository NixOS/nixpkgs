{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fuse-2.7.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/fuse/fuse-2.7.2.tar.gz;
    sha256 = "1zxssdiirf19mihbnxpy0kiix35d4256b9lani7qwqi7m940jfgv";
  };
  configureFlags = [ "--disable-kernel-module" ];

  meta = {
    homepage = http://fuse.sourceforge.net/;
    description = "Kernel module and library that allows filesystems to be implemented in user space";
  };
}
