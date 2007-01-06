{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fuse-2.6.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/fuse/fuse-2.6.1.tar.gz;
    md5 = "13e1873086a1d7a95f470bbc7428c528";
  };
  configureFlags = [ "--disable-kernel-module" ];
}
