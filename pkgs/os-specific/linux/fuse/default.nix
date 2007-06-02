{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fuse-2.6.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/fuse/fuse-2.6.5.tar.gz;
    sha256 = "0901hrhi1z6dwlgvgn75cg2268wvaz53x0knn7jplk6acwir54db";
  };
  configureFlags = [ "--disable-kernel-module" ];
}
