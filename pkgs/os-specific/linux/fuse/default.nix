{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fuse-2.4.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/fuse-2.4.1.tar.gz;
    md5 = "553bd9c5a4f3cd27f3e2b93844711e4c";
  };
  configureFlags = [ "--disable-kernel-module" ];
}
